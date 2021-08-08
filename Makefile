.PHONY: setup
setup:
	flutter pub get
	flutter packages pub run build_runner build --delete-conflicting-outputs

.PHONY: build-runner
build-runner:
	flutter packages pub run build_runner build --delete-conflicting-outputs

.PHONY: run-debug
run-debug:
	flutter run --flavor dev -t lib/main-dev.dart --debug

.PHONY: run-release
run-release:
	flutter run --flavor dev -t lib/main-dev.dart --release

.PHONY: build-ios-prd
build-ios-prd:
	flutter build ipa --flavor prd -t lib/main-prd.dart

.PHONY: build-android-prd
build-android-prd:
	flutter build appbundle --flavor prd -t lib/main-prd.dart

.PHONY: test
test:
	flutter test --coverage
	lcov --remove coverage/lcov.info '*.freezed.dart' '*.mock.dart' '*.g.dart' -o coverage/excluded_lcov.info
	genhtml coverage/excluded_lcov.info -o coverage/html
	rm -f coverage/lcov.info

.PHONY: analyze
analyze:
	flutter analyze
