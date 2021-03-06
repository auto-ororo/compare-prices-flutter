# 価格比較アプリ Compey

![google_play_future_graphic](https://user-images.githubusercontent.com/23581157/127868311-5e7dd4a9-52a8-4927-80ba-8e834cd58b8a.png)

Compay(こんぺい)は、とてもシンプルな価格比較アプリです。

日々のお買い物でアプリに価格を登録することで、お店ごとの商品の底値を簡単に把握することができます。

[![AppleStore](https://user-images.githubusercontent.com/23581157/127870868-d2d8a22d-726a-4b24-a508-76818496e1be.png)](https://apps.apple.com/jp/app/%E4%BE%A1%E6%A0%BC%E6%AF%94%E8%BC%83%E3%82%A2%E3%83%97%E3%83%AAcompey-%E3%81%93%E3%82%93%E3%81%BA%E3%81%84/id1579223519)

[![GooglePlayStore](https://user-images.githubusercontent.com/23581157/80559396-58b00400-8a18-11ea-92ba-64eab5907665.png)](https://play.google.com/store/apps/details?id=com.ororoauto.compare_prices)

## Features

- 商品の価格登録機能

    <img src="https://user-images.githubusercontent.com/23581157/127875073-bb87bec0-d3f9-4b04-ab87-498abb400029.PNG" width=300>

- 商品毎の底値一覧表示

    <img src="https://user-images.githubusercontent.com/23581157/128594395-1b61547a-748a-4243-b7f4-f8f91f00d517.PNG" width=300>

- 商品の価格ランキング表示

    <img src="https://user-images.githubusercontent.com/23581157/128594398-b6a7e46b-099e-4363-8660-4dffaba70661.PNG" width=300>

- 価格登録履歴の一覧表示

    <img src="https://user-images.githubusercontent.com/23581157/128594399-f5e2054f-3898-44fd-b841-3fa6d76e4546.PNG" width=300>

- ダークテーマ対応

    <img src="https://user-images.githubusercontent.com/23581157/127875060-657bdc14-b962-43fa-93cc-b683271093a9.PNG" width=300>

    <img src="https://user-images.githubusercontent.com/23581157/127875045-6443be3c-b1a7-4546-aa28-69b92cabe561.PNG" width=300>

### Requirements

- Android 5.0+
- iOS 9.0+

## Development

### Environments

- Flutter 2.2.3
- Dart 2.13.4
- Cocoapods 1.10.1

### How To Set Up

1. ライブラリインストール、必要なソースコードの自動生成

   ```zsh
   make setup
   ```

2. アプリ起動

- `Debug`ビルドの場合

  ```bash
  make run-debug
  ```

  - Android Studio の場合は Configurations から`Dev Debug`を実行でも可

- `Release`ビルドの場合

  ```bash
  make run-release
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

### Test

```zsh
make test
```

UnitTest,WidgetTest を実装

- UnitTest
  - domain directory
  - data directory
- WidgetTest
  - ui directory

#### Coverage

- Test 実行時、レポートを`coverage/html/index.html`に出力
- 自動生成ファイル(`*.freezed.dart`、`*.mock.dart`、`*.g.dart`)は Coverage から除外

### How To Release

#### iOS

1. Apple Developer サイトで `Provisioning Profile`を作成

2. `ipa`作成

   ```zsh
   make build-ios-prd
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
   make build-android-prd
   ```
