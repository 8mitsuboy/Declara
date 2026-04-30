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

## API キーを更新するとき

SSM の値を上書きするだけでよい。Lambda は次回 cold start 時に新しい値を読む。

```bash
aws ssm put-parameter \
  --name /declara/claude_api_key \
  --value "sk-ant-new-key..." \
  --type SecureString \
  --overwrite
```
