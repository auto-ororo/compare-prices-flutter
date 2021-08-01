# <img width=48 src="lib/ui/assets/launcher/launcher_icon.png"> 価格比較アプリ Compey

Compay(こんぺい)は、とてもシンプルな価格比較アプリです。
日々のお買い物の際に、このアプリに価格を登録することでお店ごとの商品の底値を簡単に把握することができます。

## Features

- 商品の価格登録機能
- 商品毎の底値一覧表示
- 商品の価格ランキング表示
- 価格登録履歴の一覧表示
- ダークテーマ対応

## Development

### Requirements

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

  - Android Studio の Configurations から`Dev Debug`を実行、又は下記コマンドを実行

    ```bas h
    flutter run --flavor dev -t lib/main-dev.dart --debug
    ```

- `Release`ビルドの場合

  - Android Studio の Configurations から`Dev Release`を実行、又は下記コマンドを実行

    ```bas h
    flutter run --flavor dev -t lib/main-dev.dart --release
    ```

### Flavors

| Flavor | Summary            | Application Id Suffix |
| ------ | ------------------ | --------------------- |
| dev    | 開発時に設定       | \*.dev                |
| prd    | アプリ配布時に設定 | なし                  |

### Embedded Libraries

| Library                                                                   | Summary                                            |
| ------------------------------------------------------------------------- | -------------------------------------------------- |
| [state_notifier](https://pub.dev/packages/state_notifier)                 | 状態保持/変更通知                                  |
| [hooks_riverpod](https://pub.dev/packages/hooks_riverpod)                 | 状態管理/DI                                        |
| [flutter_hooks](https://pub.dev/packages/flutter_hooks)                   | Flutter 版の ReactHooks                            |
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

