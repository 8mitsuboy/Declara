# 設計: Terraform + SSM によるタスク生成 Lambda のAPIキー管理

## ステータス
Approved

## 背景

`infra/` には Cognito / API Gateway / Lambda の Terraform リソースがすでに存在する。
しかし Lambda に `CLAUDE_API_KEY` を渡す手段が未実装で、このままでは Lambda 実行時にエラーになる。

APIキーをクライアント（Flutter）に持たせないという ADR-001 の方針に従い、
サーバ側（Lambda）でのみキーを保持する必要がある。

## 目的

- Lambda が `CLAUDE_API_KEY` を安全に取得できるようにする
- Terraform の state ファイルにAPIキーの実値を残さない
- キーを後から変更しやすい構造にする

## 採用方針

**AWS SSM Parameter Store (SecureString) + Lambda cold start 読み込み**

- Terraform は SSM パラメータの「箱」（パス・タイプ・`REPLACE_ME` のプレースホルダー）だけを管理する
- `lifecycle { ignore_changes = [value] }` により、Terraform が値を上書きしないようにする
- 実際のAPIキーは `terraform apply` 後に AWS CLI で手動設定する
- Lambda はモジュールレベルの Promise で cold start 時に SSM から一度だけ取得・メモリキャッシュする

## 変更範囲

### 1. `infra/main.tf`

#### SSM パラメータ追加

```hcl
resource "aws_ssm_parameter" "claude_api_key" {
  name  = "/declara/claude_api_key"
  type  = "SecureString"
  value = "REPLACE_ME"

  lifecycle {
    ignore_changes = [value]
  }
}
```

#### Lambda IAM ロールに SSM 読み取り権限を追加

```hcl
data "aws_iam_policy_document" "task_generation_lambda_ssm" {
  statement {
    actions   = ["ssm:GetParameter"]
    resources = [aws_ssm_parameter.claude_api_key.arn]
  }
}

resource "aws_iam_role_policy" "task_generation_lambda_ssm" {
  name   = "declara-task-generation-lambda-ssm"
  role   = aws_iam_role.task_generation_lambda.id
  policy = data.aws_iam_policy_document.task_generation_lambda_ssm.json
}
```

#### Lambda 関数に環境変数を追加

```hcl
resource "aws_lambda_function" "task_generation" {
  # 既存の設定はそのまま

  environment {
    variables = {
      CLAUDE_API_KEY_SSM_PATH = aws_ssm_parameter.claude_api_key.name
    }
  }
}
```

パスそのものは秘密情報ではないため、環境変数で渡して問題ない。

### 2. `backend/lambda/task_generation/src/index.ts`

#### 変更方針

- モジュールレベルで SSM からキーを取得する Promise を一度だけ生成してキャッシュする
- `createLambdaHandler` が受け取る `dependencies` に `getApiKey` を追加し、テスト時に差し替え可能にする

#### 変更後のイメージ

```ts
import { SSMClient, GetParameterCommand } from "@aws-sdk/client-ssm";

const ssmClient = new SSMClient({});

// cold start 時に一度だけ解決される Promise
const apiKeyPromise: Promise<string> = fetchApiKeyFromSsm(
  getRequiredEnv("CLAUDE_API_KEY_SSM_PATH")
);

export function createLambdaHandler(dependencies?: {
  generateTasks?: (declarationTitle: string) => Promise<string[]>;
  getApiKey?: () => Promise<string>;
}) {
  const getApiKey = dependencies?.getApiKey ?? (() => apiKeyPromise);

  const generateTasks =
    dependencies?.generateTasks ??
    (async (declarationTitle: string) => {
      const apiKey = await getApiKey();
      return generateTaskTitlesFromAnthropic({ apiKey, declarationTitle });
    });

  return createTaskGenerationHandler({ generateTasks });
}

async function fetchApiKeyFromSsm(path: string): Promise<string> {
  const command = new GetParameterCommand({
    Name: path,
    WithDecryption: true,
  });
  const response = await ssmClient.send(command);
  const value = response.Parameter?.Value;
  if (!value) throw new Error(`SSM parameter ${path} has no value.`);
  return value;
}
```

#### テスト時の差し替え例

```ts
const handler = createLambdaHandler({
  getApiKey: async () => "test-key",
  generateTasks: async () => ["タスク1"],
});
```

### 3. `backend/lambda/task_generation/package.json`

esbuild の build スクリプトに `--external:@aws-sdk/client-ssm` を追加する。
`@aws-sdk/*` は Node.js 20 Lambda ランタイムに同梱されているため、bundle に含める必要がない。

```json
"build": "esbuild src/index.ts --bundle --platform=node --format=cjs --target=node20 --external:@aws-sdk/client-ssm --outfile=dist/index.js"
```

### 4. `infra/README.md`（新規作成）

デプロイ手順を記載する:

1. Lambda をビルド: `cd backend/lambda/task_generation && pnpm build`
2. Terraform を適用: `cd infra && terraform init && terraform apply`
3. SSM にAPIキーを設定:
   ```
   aws ssm put-parameter \
     --name /declara/claude_api_key \
     --value "sk-ant-..." \
     --type SecureString \
     --overwrite
   ```
4. 動作確認: Lambda は次の cold start で SSM から値を読む。再デプロイは不要。

## エラーハンドリング

- SSM への接続失敗や値が空の場合は cold start 時に Lambda がエラーを投げる
- これにより「キー未設定のまま稼働」を防げる

## テスト方針

- `index.test.ts` は `getApiKey` を差し替えてテスト（SSM の実呼び出しなし）
- `anthropicClient.test.ts` は既存どおり `fetchImpl` を差し替え

## 対象外

- SSM パラメータの KMS キー管理（デフォルトの AWS マネージドキーを使用）
- CI/CD パイプライン（手動デプロイ前提）
- Lambda のウォームアップ戦略
