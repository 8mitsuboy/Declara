# 現在の施策: 認証付きタスク生成 API

## 目的
- タスク生成を、クライアント内の API キー直叩きではなく、認証付きのサーバ API 経由に置き換える。

## この施策に着手する理由
- クライアント配布物に API キーを持たせる構成は本番運用に向かない。
- 今後の認可、使用量制御、モデル差し替え、監査のためにサーバ境界が必要。

## 対象範囲
- Cognito によるログイン基盤
- API Gateway 経由での認証付き API
- Lambda によるタスク生成処理
- Flutter 側の `LambdaAiService` 利用
- Terraform での関連リソース管理

## 対象外
- 高度な課金制御
- 詳細な監視ダッシュボード
- 複数 AI ベンダー切り替え

## 現時点の前提
- 本番の AI 呼び出し経路は `LambdaAiService` を基本とする。
- `ClaudeAiService` はローカル検証用途に限定し、将来的には削除候補とする。
- API の入口は公開 Lambda URL ではなく、認証付き API Gateway を前提にする。

## 関連チケット
- `#1` ログイン画面作成
- `#2` `cognito, APIGateway, Lambda` のリソースを Terraform で作成
- `#3` Lambda で実行するサブタスク生成ロジックファイルを作成
- `#4` repositoryImpl から Lambda へ通信ロジックを作成

## 作業順
1. `#1` でログイン導線を用意する
2. `#2` で認証・API・実行基盤を作る
3. `#3` で Lambda 側のアプリ専用ロジックを作る
4. `#4` で Flutter 側を新しい API に接続する

## 想定ブランチ名
- `feature/cognito-api-gateway-lambda-task-generation`

## 未解決事項
- Cognito の導入範囲をメールアドレス認証のみに絞るか
- API のレスポンス契約をどこまでシンプルにするか
- ローカル開発時の認証回避手段をどう設計するか

## 完了条件
- Flutter アプリから認証済みユーザーのみがタスク生成 API を呼べる
- クライアント配布物に AI ベンダー API キーを含めない
- API 契約と主要な設計判断が docs に残っている
