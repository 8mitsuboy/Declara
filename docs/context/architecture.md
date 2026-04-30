# Architecture

## Layering
- Presentation: `lib/pages`, `lib/widgets`
- Application / Composition: `lib/providers.dart`
- Domain: `lib/domain`
- Data: `lib/data`
- Repository Interfaces: `lib/repository`

## Expectations
- Domain は外部依存を持たない。
- 業務ルールは Widget に閉じ込めず、Domain またはユースケース相当の境界で表現する。
- Data 層は外部 API や DB の都合を吸収し、Domain 側へ漏らさない。
- 実装差し替えが起こりうる境界では、インターフェースを先に定義する。

## UI Rules
- Riverpod を参照する Widget は `HookConsumerWidget` を使う。
- Riverpod を参照しない Widget は `HookWidget` を使う。
- `StatefulWidget` は原則使わない。
- ページ固有 Widget は対象ページ配下の `widgets/` に置く。

## Infrastructure Direction
- 本番で秘密情報をクライアントに保持しない。
- 外部 AI ベンダーの API キーやレスポンス形状は、できるだけサーバ側で吸収する。
- 認証・認可・API 契約はクライアントから独立して扱えるようにする。

## Monorepo Direction
- Flutter アプリ本体と、Lambda / Terraform などの周辺コンポーネントは同一リポジトリで管理する。
- ただし責務はディレクトリで分離し、`lib/` にインフラ都合を混ぜない。
- 想定構成:
  - `lib/`
  - `backend/lambda/`
  - `infra/`
