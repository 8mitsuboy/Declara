# Development Rules

## 目的
- このプロジェクトは、実用的なタスク分解アプリを作ることを目的とする。
- 同時に、チームの DDD と Flutter の学習・成長に寄与することを目的とする。

## 開発の優先方針
- DDD のレイヤー分離や境界の理解が深まる判断を優先する。
- Flutter の主要パターン（状態管理、Widget 分割、非同期処理、テスト）を学べる実装を優先する。
- MVP の現実性は保ちつつ、明確な理由なくアーキテクチャの明瞭性を下げない。

## Architecture
- `domain/`: ドメインモデル（外部依存なし）
- `repository/`: リポジトリインターフェース
- `data/`: リポジトリ実装、DB定義、外部サービス
- `pages/`: UI（ページ単位でフォルダ分け）
- `providers.dart`: DIコンテナ（Riverpod）

## DDD に関する期待
- Presentation / Application / Domain / Data の責務分離を維持する。
- UI やインフラ都合を Domain に漏らさない。
- 業務ルールは Widget ではなく、ユースケースとドメインモデルで表現する。
- 境界ではインターフェースを使い、将来の実装差し替えを可能にする。

## Widget Implementation
- ウィジェットは原則 `HookWidget` または `HookConsumerWidget` で実装する
  - Riverpod プロバイダーを参照する場合は `HookConsumerWidget`、しない場合は `HookWidget`
  - `StatefulWidget` は使わない。ライフサイクル管理（`AnimationController` など）は `flutter_hooks` のフックに委ねる

## Widget Structure
- ページ固有のウィジェットを分割する際は、対象ページフォルダ内に `widgets/` フォルダを作成し、そこに配置する
  - 例: `lib/pages/declaration_page/widgets/declaration_tile.dart`
- アプリ全体で共通利用するウィジェットは `lib/widgets/` に配置する

## Flutter に関する期待
- 責務が明確な小さく合成可能な Widget を基本とする。
- 状態は明示的かつテスト可能に保つ。
- 非同期・エラー・ローディング状態を一貫した方針で扱う。
- 可能な限り機能追加と同時にテストを追加する（まず Unit Test、必要に応じて Widget Test）。
