# Terraform + SSM による Lambda APIキー管理 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Lambda が CLAUDE_API_KEY を SSM Parameter Store から安全に取得できるよう、Terraform リソースと Lambda コードを整備する。

**Architecture:** Lambda のモジュールレベルで SSM から APIキーをレイジー取得・キャッシュする。Terraform は SSM パラメータの「箱」のみ管理し、キーの実値は `terraform apply` 後に手動設定する（Terraform state に秘密情報を含めない）。

**Tech Stack:** Terraform (AWS provider ~5.0), TypeScript (Node.js 20), `@aws-sdk/client-ssm` v3, pnpm, esbuild

---

## File Map

| ファイル | 変更種別 | 内容 |
|---|---|---|
| `backend/lambda/task_generation/src/index.ts` | 修正 | SSM 読み込みロジック追加、`getApiKey` DI 追加 |
| `backend/lambda/task_generation/src/index.test.ts` | 修正 | `getApiKey` 経路のテスト追加 |
| `backend/lambda/task_generation/package.json` | 修正 | devDependency 追加、build script に `--external` 追加 |
| `infra/main.tf` | 修正 | SSM パラメータ、IAM ポリシー、Lambda env var 追加 |
| `infra/README.md` | 新規作成 | デプロイ手順 |

---

## Task 1: `@aws-sdk/client-ssm` を devDependency に追加

**Files:**
- Modify: `backend/lambda/task_generation/package.json`

- [ ] **Step 1: devDependency を追加する**

```bash
cd backend/lambda/task_generation
pnpm add -D @aws-sdk/client-ssm
```

- [ ] **Step 2: インストールを確認する**

```bash
node -e "import('@aws-sdk/client-ssm').then(m => console.log('OK:', Object.keys(m).length, 'exports'))"
```

期待出力: `OK: <数字> exports`

- [ ] **Step 3: コミットする**

```bash
git add backend/lambda/task_generation/package.json backend/lambda/task_generation/pnpm-lock.yaml
git commit -m "chore(lambda): add @aws-sdk/client-ssm as dev dependency"
```

---

## Task 2: `index.test.ts` に `getApiKey` 経路のテストを追加（先にテストを書く）

**Files:**
- Modify: `backend/lambda/task_generation/src/index.test.ts`

- [ ] **Step 1: 失敗テストを追加する**

`backend/lambda/task_generation/src/index.test.ts` の末尾に追加:

```ts
test("generateTasks を省略した場合、getApiKey を呼ぶ", async () => {
  const handler = createLambdaHandler({
    getApiKey: async () => {
      throw new Error("getApiKey was called");
    },
  });

  await assert.rejects(
    () =>
      handler({
        body: JSON.stringify({ declarationTitle: "毎日英語を勉強する" }),
      }),
    (err: Error) => {
      assert.equal(err.message, "getApiKey was called");
      return true;
    },
  );
});
```

- [ ] **Step 2: テストが失敗することを確認する**

```bash
node --test src/index.test.ts
```

期待出力: `generateTasks を省略した場合、getApiKey を呼ぶ` が FAIL になること。
現行の `createLambdaHandler` は `getApiKey` を無視し、`process.env.CLAUDE_API_KEY` を読もうとするため、`assert.rejects` の error message 検証で失敗する（`'CLAUDE_API_KEY is required.' !== 'getApiKey was called'` のようなエラー）。

---

## Task 3: `index.ts` に SSM 読み込みロジックを実装してテストをパスさせる

**Files:**
- Modify: `backend/lambda/task_generation/src/index.ts`

- [ ] **Step 1: `index.ts` を以下の内容に書き換える**

```ts
import { SSMClient, GetParameterCommand } from "@aws-sdk/client-ssm";
import { generateTaskTitlesFromAnthropic } from "./anthropicClient.ts";
import { createTaskGenerationHandler } from "./handler.ts";

const ssmClient = new SSMClient({});
let apiKeyPromise: Promise<string> | undefined;

function getDefaultApiKey(): Promise<string> {
  if (!apiKeyPromise) {
    apiKeyPromise = fetchApiKeyFromSsm(getRequiredEnv("CLAUDE_API_KEY_SSM_PATH"));
  }
  return apiKeyPromise;
}

export function createLambdaHandler(dependencies?: {
  generateTasks?: (declarationTitle: string) => Promise<string[]>;
  getApiKey?: () => Promise<string>;
}) {
  const getApiKey = dependencies?.getApiKey ?? getDefaultApiKey;

  const generateTasks =
    dependencies?.generateTasks ??
    (async (declarationTitle: string) => {
      const apiKey = await getApiKey();
      return generateTaskTitlesFromAnthropic({ apiKey, declarationTitle });
    });

  return createTaskGenerationHandler({ generateTasks });
}

export const handler = createLambdaHandler();

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

function getRequiredEnv(name: string): string {
  const value = process.env[name];
  if (typeof value !== "string" || value.trim() === "") {
    throw new Error(`${name} is required.`);
  }
  return value;
}
```

- [ ] **Step 2: 全テストが通ることを確認する**

```bash
node --test
```

期待出力:
```
✔ Lambda entrypoint は generateTasks で返した tasks をそのまま返す
✔ generateTasks を省略した場合、getApiKey を呼ぶ
...（他のテストも全て ✔）
tests 9
pass 9
fail 0
```

- [ ] **Step 3: `package.json` の build script に `--external:@aws-sdk/client-ssm` を追加する**

`backend/lambda/task_generation/package.json` の `build` スクリプトを以下に変更:

```json
"build": "esbuild src/index.ts --bundle --platform=node --format=cjs --target=node20 --external:@aws-sdk/client-ssm --outfile=dist/index.js"
```

`--external:@aws-sdk/client-ssm` を追加した理由: Lambda の Node.js 20 ランタイムには AWS SDK v3 が同梱されているため、bundle に含める必要がなく、含めると bundle サイズが無駄に増える。

- [ ] **Step 4: ビルドが通ることを確認する**

```bash
pnpm build
```

期待出力: エラーなし、`dist/index.js` が更新されること

- [ ] **Step 5: コミットする**

```bash
git add src/index.ts src/index.test.ts package.json
git commit -m "feat(lambda): SSM から CLAUDE_API_KEY を cold start 時に取得するよう変更"
```

---

## Task 4: Terraform に SSM パラメータ・IAM ポリシー・Lambda 環境変数を追加する

**Files:**
- Modify: `infra/main.tf`

- [ ] **Step 1: `infra/main.tf` の `aws_iam_role_policy_attachment` ブロックの直後に SSM パラメータと IAM リソースを追加する**

`aws_iam_role_policy_attachment.task_generation_lambda_basic_execution` の閉じ括弧 `}` の直後に以下を追加:

```hcl
resource "aws_ssm_parameter" "claude_api_key" {
  name  = "/declara/claude_api_key"
  type  = "SecureString"
  value = "REPLACE_ME"

  lifecycle {
    ignore_changes = [value]
  }
}

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

- [ ] **Step 2: `aws_lambda_function.task_generation` リソースに `environment` ブロックを追加する**

現在の `aws_lambda_function.task_generation`:
```hcl
resource "aws_lambda_function" "task_generation" {
  function_name = "declara-task-generation"
  role          = aws_iam_role.task_generation_lambda.arn

  runtime = "nodejs20.x"
  handler = "index.handler"

  filename         = data.archive_file.task_generation_lambda.output_path
  source_code_hash = data.archive_file.task_generation_lambda.output_base64sha256
}
```

変更後:
```hcl
resource "aws_lambda_function" "task_generation" {
  function_name = "declara-task-generation"
  role          = aws_iam_role.task_generation_lambda.arn

  runtime = "nodejs20.x"
  handler = "index.handler"

  filename         = data.archive_file.task_generation_lambda.output_path
  source_code_hash = data.archive_file.task_generation_lambda.output_base64sha256

  environment {
    variables = {
      CLAUDE_API_KEY_SSM_PATH = aws_ssm_parameter.claude_api_key.name
    }
  }
}
```

- [ ] **Step 3: Terraform の構文を検証する**

```bash
cd infra
terraform validate
```

期待出力: `Success! The configuration is valid.`

- [ ] **Step 4: コミットする**

```bash
git add infra/main.tf
git commit -m "feat(infra): SSM パラメータ・IAM ポリシー・Lambda 環境変数を Terraform に追加"
```

---

## Task 5: `infra/README.md` を作成する

**Files:**
- Create: `infra/README.md`

- [ ] **Step 1: `infra/README.md` を作成する**

```markdown
# Declara インフラ

Terraform で管理する AWS リソース一覧と、デプロイ手順を記載する。

## 管理リソース

- Cognito User Pool / User Pool Client（メールアドレス認証）
- Lambda 関数（タスク生成）
- API Gateway HTTP API（JWT 認証付き）
- SSM Parameter Store（Lambda 用 API キー）

## 初回デプロイ手順

### 1. Lambda をビルドする

```bash
cd backend/lambda/task_generation
pnpm install
pnpm build
```

### 2. Terraform を適用する

```bash
cd infra
terraform init
terraform apply
```

### 3. SSM に CLAUDE_API_KEY を設定する

`terraform apply` が完了した後、実際の API キーを SSM に設定する。
この値は Terraform では管理しない（`lifecycle.ignore_changes` により上書きされない）。

```bash
aws ssm put-parameter \
  --name /declara/claude_api_key \
  --value "sk-ant-..." \
  --type SecureString \
  --overwrite
```

### 4. 動作確認

Lambda は次の cold start（次回リクエスト時）に SSM から値を読む。
再デプロイは不要。

```bash
# API エンドポイントは terraform output で確認できる
terraform output task_generation_api_endpoint
```

## APIキーを更新するとき

SSM の値を上書きするだけでよい。Lambda は次回 cold start 時に新しい値を読む。

```bash
aws ssm put-parameter \
  --name /declara/claude_api_key \
  --value "sk-ant-new-key..." \
  --type SecureString \
  --overwrite
```
```

- [ ] **Step 2: コミットする**

```bash
git add infra/README.md
git commit -m "docs(infra): デプロイ手順の README を追加"
```
