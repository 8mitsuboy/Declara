# Development Rules

## Architecture
- `domain/`: ドメインモデル（外部依存なし）
- `repository/`: リポジトリインターフェース
- `data/`: リポジトリ実装、DB定義、外部サービス
- `pages/`: UI（ページ単位でフォルダ分け）
- `providers.dart`: DIコンテナ（Riverpod）

## Widget Structure
- ページ固有のウィジェットを分割する際は、対象ページフォルダ内に `widgets/` フォルダを作成し、そこに配置する
  - 例: `lib/pages/declaration_page/widgets/declaration_tile.dart`
- アプリ全体で共通利用するウィジェットは `lib/widgets/` に配置する
