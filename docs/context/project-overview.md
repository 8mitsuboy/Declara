# Project Overview

## Purpose
- Declara は、宣言を具体的なタスクに分解して実行を支援するアプリである。
- 同時に、チームの DDD と Flutter の学習・成長に寄与することを目指す。

## Product Principles
- 実用的な MVP を意識しつつ、学習価値のある構造を優先する。
- 一時的な実装都合で Domain に UI やインフラの関心を漏らさない。
- 変更容易性より前に、責務の明瞭さを確保する。

## Current Technical Stack
- Flutter
- Riverpod
- flutter_hooks
- Drift
- Dio

## Repo Structure
- `lib/domain`: ドメインモデル
- `lib/repository`: リポジトリインターフェース
- `lib/data`: データアクセス実装、外部サービス
- `lib/pages`: ページ単位の UI
- `lib/widgets`: アプリ全体で共通利用する Widget
- `docs/context`: 継続的に必要な文脈
- `docs/decisions`: ADR

## How To Use This Document
- まずはこのファイルでプロジェクトの目的と境界を掴む。
- 実装前には `docs/context/architecture.md` も読む。
- 今進めている施策がある場合は、対応する `current-initiative` を読む。
