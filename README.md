# 価格比較アプリ Compey

![google_play_future_graphic](https://user-images.githubusercontent.com/23581157/127868311-5e7dd4a9-52a8-4927-80ba-8e834cd58b8a.png)

Compay(こんぺい)は、とてもシンプルな価格比較アプリです。
日々のお買い物の際に、このアプリに価格を登録することでお店ごとの商品の底値を簡単に把握することができます。

[![AppleStore](https://user-images.githubusercontent.com/23581157/127870868-d2d8a22d-726a-4b24-a508-76818496e1be.png)](https://apps.apple.com/jp/app/%E4%BE%A1%E6%A0%BC%E6%AF%94%E8%BC%83%E3%82%A2%E3%83%97%E3%83%AAcompey-%E3%81%93%E3%82%93%E3%81%BA%E3%81%84/id1579223519)

[![GooglePlayStore](https://user-images.githubusercontent.com/23581157/80559396-58b00400-8a18-11ea-92ba-64eab5907665.png)](https://play.google.com/store/apps/details?id=com.ororo.auto.jigokumimi)

## Features

- 商品の価格登録機能
- 商品毎の底値一覧表示
- 商品の価格ランキング表示
- 価格登録履歴の一覧表示
- ダークテーマ対応

### Requirements

- Android 5.0+
- iOS 9.0+

## Development

### Environments

- Flutter 2.2.3
- Dart 2.13.4
- Cocoapods 1.10.1

### How To Set Up

1. ライブラリインストール

   ```zsh
   flutter pub get
   ```

2. 必要なソースコードの自動生成

   ```zsh
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

3. アプリ起動

- `Debug`ビルドの場合

  ```bash
  flutter run --flavor dev -t lib/main-dev.dart --debug
  ```

  - Android Studio の Configurations から`Dev Debug`を実行、又は下記コマンドを実行

- `Release`ビルドの場合

  ```bash
  flutter run --flavor dev -t lib/main-dev.dart --release
  ```

  - Android Studio の場合は Configurations から`Dev Release`を実行でも可

### Flavors

| Flavor | Description  | Application Id Suffix |
| ------ | ------------ | --------------------- |
| dev    | 開発用       | \*.dev                |
| prd    | アプリ配布用 | なし                  |

### Embedded Libraries

| Library                                                                   | Description                                        |
| ------------------------------------------------------------------------- | -------------------------------------------------- |
| [flutter_hooks](https://pub.dev/packages/flutter_hooks)                   | Flutter 版の ReactHooks                            |
| [hooks_riverpod](https://pub.dev/packages/hooks_riverpod)                 | 状態管理/DI                                        |
| [state_notifier](https://pub.dev/packages/state_notifier)                 | 状態保持/変更通知                                  |
| [flutter_slidable](https://pub.dev/packages/flutter_slidable)             | List にスライドメニューを実装する Widget           |
| [freezed](https://pub.dev/packages/freezed)                               | Immutable クラス,Sealed クラス, Union クラスの生成 |
| [intl](https://pub.dev/packages/intl)                                     | 文字列リソース管理、多言語化                       |
| [uuid](https://pub.dev/packages/uuid)                                     | UUID 生成                                          |
| [hive](https://pub.dev/packages/hive)                                     | ローカル DB                                        |
| [package_info](https://pub.dev/packages/package_info)                     | バージョン情報、ビルド番号をアプリ上で取得         |
| [build_runner](https://pub.dev/packages/build_runner)                     | コード生成                                         |
| [mockito](https://pub.dev/packages/mockito)                               | クラスのモック化                                   |
| [flutter_flavorizr](https://pub.dev/packages/flutter_flavorizr)           | Flavor 設定の一括管理                              |
| [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) | アプリアイコンの設定                               |
| [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)   | アプリ起動時画面(Splash)の設定                     |

### Architecture

MVVM をベースとした Layered Architecture

<img src="https://user-images.githubusercontent.com/23581157/127873558-87e9c8b9-f132-4c23-bded-9c61f2cd4d93.png" width=500>

- View(Widget)
  - HookWidget を継承(Flutter Hooks 提供)
  - ViewModel の State,Stream を監視して UI に反映
- ViewModel
  - StateNotifier を継承
  - 画面の状態を State として保持し、状態変更時に通知
  - 「例外の発生」、「データ登録完了」等のイベントは Stream として通知
- UseCase
  - ビジネスロジック
  - 戻り値は Result 型に包んで返却
- Repository
  - 永続化先の抽象クラス
- Concrete Repository
  - 永続化先は Repository を継承
  - ※現時点の永続化先は Hive(LocalDB)のみ
- Model
  - アプリケーション全体で取り扱うデータモデル
- Entity
  - 永続化先のスキーマに対応したデータクラス

#### Directories

`libs`配下のディレクトリを記載

| Directory | Contents                                                             |
| --------- | -------------------------------------------------------------------- |
| domain    | UseCase、Model、Repository                                           |
| data      | 永続化先(Repository を継承)、Entity、永続化先固有の Util クラス/関数 |
| ui        | View(Widget)、ViewModel、文言/画像等の各種リソース(assets)           |

### How To Release

#### iOS

1. Apple Developer サイトで `Provisioning Profile`を作成

2. `ipa`作成

   ```zsh
   flutter build ipa --flavor prd -t lib/main-prd.dart
   ```

#### Android

1. `keystore(jks)`を作成

2. `android/key.properties`に 1.で作成した`keystore`情報を設定

   ```txt
   storePassword=****
   keyPassword=****
   keyAlias=****
   storeFile=<location of the key store file, such as /Users/<user name>/upload-keystore.jks>
   ```

3. `AppBundle`作成

```zsh
flutter build appbundle --flavor prd -t lib/main-prd.dart
```
