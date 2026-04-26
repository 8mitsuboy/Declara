# AGENTS.md

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

## Widget 実装方針
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

## エージェントの振る舞い
- 代替案を示す際は、学習価値と保守性のトレードオフを説明する。
- その場しのぎの実装が DDD / Flutter の学習目標と衝突する場合、まず構造化された案を提示する。
- コードを変更する際は、命名・構造・最小限の要点コメントによって、変更前より理解しやすい状態にする。

## 出力スタイル
- 説明は簡潔かつ実行可能な内容にする。
- 必要に応じて、その設計判断が DDD / Flutter 学習にどう寄与するかを添える。

## Context Docs
- 作業開始時は、必要に応じて `docs/context/project-overview.md` と `docs/context/architecture.md` を参照する。
- 進行中の施策に着手する際は、該当する `docs/context/current-initiative-*.md` を参照する。
- チケットを横断する重要な設計判断は `docs/decisions/` 配下の ADR を参照する。

## Context 運用ルール
- `AGENTS.md` には、このリポジトリで常に有効な共通前提だけを書く。
- チケット単位・施策単位の前提は `docs/context/current-initiative-*.md` に書く。
- 長期的に参照される設計判断は `docs/decisions/ADR-*.md` に記録する。
