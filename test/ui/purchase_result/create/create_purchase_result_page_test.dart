import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/create_purchase_result_use_case.dart';
import 'package:compare_prices/domain/usecases/get_commodities_use_case.dart';
import 'package:compare_prices/domain/usecases/get_shops_use_case.dart';
import 'package:compare_prices/ui/common/extensions/datetime_extensions.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/picker_form_field.dart';
import 'package:compare_prices/ui/purchase_result/create/create_purchase_result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../helper.dart';
import '../../../mocks/generate.mocks.dart';

void main() {
  group('CreatePurchaseResultPage', () {
    late MockGetCommoditiesUseCase getCommoditiesUseCase;
    late MockGetShopsUseCase getShopsUseCase;
    late MockCreatePurchaseResultUseCase createPurchaseResultUseCase;

    late List<Override> overrides;

    final commodity = Commodity.create("commodityName1", QuantityType.gram());

    final shop = Shop.createByName("shopName1");

    final price = 8;
    final quantity = 2;
    final now = DateTime.now();
    final purchaseDate = DateTime(now.year, now.month, now.day);

    final purchaseResult = PurchaseResult.create(
      commodity: commodity,
      shop: shop,
      price: price,
      quantity: quantity,
      purchaseDate: purchaseDate,
    );

    setUp(() {
      getCommoditiesUseCase = MockGetCommoditiesUseCase();
      getShopsUseCase = MockGetShopsUseCase();
      createPurchaseResultUseCase = MockCreatePurchaseResultUseCase();

      overrides = [
        getCommoditiesUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetCommoditiesUseCase>(
              (ref) => getCommoditiesUseCase),
        ),
        getShopsUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetShopsUseCase>((ref) => getShopsUseCase),
        ),
        createPurchaseResultUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<CreatePurchaseResultUseCase>(
              (ref) => createPurchaseResultUseCase),
        )
      ];
    });

    group('初期状態', () {
      testWidgets('Paramで商品が渡された場合、商品名、Unitの初期値が設定され商品選択ダイアログを開けないこと',
          (WidgetTester tester) async {
        await tester.pumpAppWidget(
            CreatePurchaseResultPage(
              initialCommodity: commodity,
            ),
            overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CreatePurchaseResultPage);

        expect(find.text(commodity.name), findsOneWidget);
        expect(
            find.text(commodity.quantityType.suffix(context)), findsOneWidget);
        expect(
            find.text(commodity.quantityType.label(context)), findsOneWidget);
        expect(find.text(commodity.quantityType.unit().toString()),
            findsOneWidget);
        expect(find.text(DateTime.now().toFormattedString(context)),
            findsOneWidget);

        expect(
            find.byWidgetPredicate((widget) =>
                widget is AbsorbPointer && widget.absorbing == true),
            findsOneWidget);
      });

      testWidgets('Paramで商品が渡されなかった場合、数量の初期値が設定され商品選択ダイアログを開けること',
          (WidgetTester tester) async {
        await tester.pumpAppWidget(
            CreatePurchaseResultPage(
              initialCommodity: null,
            ),
            overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CreatePurchaseResultPage);

        expect(find.text(QuantityType.count().label(context)), findsOneWidget);
        expect(find.text(QuantityType.count().suffix(context)), findsOneWidget);
        expect(
            find.text(QuantityType.count().unit().toString()), findsOneWidget);
        expect(find.text(DateTime.now().toFormattedString(context)),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is AbsorbPointer && widget.absorbing == true),
            findsNothing);
      });
    });

    group('登録', () {
      testWidgets('商品、店舗、量、価格、購入日が入力された上で登録処理が行われること',
          (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([commodity]));
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop]));
        when(createPurchaseResultUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(purchaseResult));

        await tester.pumpAppWidget(
            CreatePurchaseResultPage(
              initialCommodity: null,
            ),
            overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CreatePurchaseResultPage);

        // 数量を空にする
        await tester.tap(find.byWidgetPredicate((widget) =>
            widget is PickerFormField &&
            widget.labelText == QuantityType.count().label(context)));
        await tester.pumpAndSettle();
        await tester.tap(find.text("C"));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppLocalizations.of(context)!.commonOk));
        await tester.pumpAndSettle();

        await tester
            .tap(find.text(AppLocalizations.of(context)!.commonRegister));
        await tester.pumpAndSettle();
        expect(
            find.text(AppLocalizations.of(context)!
                .createPurchaseResultInvalidCommodity),
            findsOneWidget);
        expect(
            find.text(
                AppLocalizations.of(context)!.createPurchaseResultInvalidShop),
            findsOneWidget);
        expect(
            find.text(
                AppLocalizations.of(context)!.createPurchaseResultInvalidPrice),
            findsOneWidget);
        expect(
            find.text(AppLocalizations.of(context)!
                .createPurchaseResultInvalidAmount),
            findsOneWidget);
        expect(find.byType(CreatePurchaseResultPage), findsOneWidget);

        // 商品選択
        await tester.tap(find.byWidgetPredicate((widget) =>
            widget is PickerFormField &&
            widget.labelText == AppLocalizations.of(context)!.commonCommodity));
        await tester.pumpAndSettle();
        await tester.tap(find.text(commodity.name));
        await tester.pumpAndSettle();

        await tester
            .tap(find.text(AppLocalizations.of(context)!.commonRegister));
        await tester.pumpAndSettle();

        expect(
            find.text(AppLocalizations.of(context)!
                .createPurchaseResultInvalidCommodity),
            findsNothing);
        expect(
            find.text(
                AppLocalizations.of(context)!.createPurchaseResultInvalidShop),
            findsOneWidget);
        expect(
            find.text(
                AppLocalizations.of(context)!.createPurchaseResultInvalidPrice),
            findsOneWidget);
        expect(
            find.text(AppLocalizations.of(context)!
                .createPurchaseResultInvalidAmount),
            findsNothing);
        expect(find.byType(CreatePurchaseResultPage), findsOneWidget);

        // 店舗選択
        await tester.tap(find.byWidgetPredicate((widget) =>
            widget is PickerFormField &&
            widget.labelText == AppLocalizations.of(context)!.commonShop));
        await tester.pumpAndSettle();
        await tester.tap(find.text(shop.name));
        await tester.pumpAndSettle();

        await tester
            .tap(find.text(AppLocalizations.of(context)!.commonRegister));
        await tester.pumpAndSettle();

        expect(
            find.text(AppLocalizations.of(context)!
                .createPurchaseResultInvalidCommodity),
            findsNothing);
        expect(
            find.text(
                AppLocalizations.of(context)!.createPurchaseResultInvalidShop),
            findsNothing);
        expect(
            find.text(
                AppLocalizations.of(context)!.createPurchaseResultInvalidPrice),
            findsOneWidget);
        expect(
            find.text(AppLocalizations.of(context)!
                .createPurchaseResultInvalidAmount),
            findsNothing);
        expect(find.byType(CreatePurchaseResultPage), findsOneWidget);

        // 数量を入力
        await tester.tap(find.byWidgetPredicate((widget) =>
            widget is PickerFormField &&
            widget.labelText == commodity.quantityType.label(context)));
        await tester.pumpAndSettle();
        await tester.tap(find.text("C"));
        await tester.pumpAndSettle();
        await tester.tap(find.text(quantity.toString()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppLocalizations.of(context)!.commonOk));
        await tester.pumpAndSettle();

        await tester
            .tap(find.text(AppLocalizations.of(context)!.commonRegister));
        await tester.pumpAndSettle();
        expect(
            find.text(AppLocalizations.of(context)!
                .createPurchaseResultInvalidCommodity),
            findsNothing);
        expect(
            find.text(
                AppLocalizations.of(context)!.createPurchaseResultInvalidShop),
            findsNothing);
        expect(
            find.text(
                AppLocalizations.of(context)!.createPurchaseResultInvalidPrice),
            findsOneWidget);
        expect(
            find.text(AppLocalizations.of(context)!
                .createPurchaseResultInvalidAmount),
            findsNothing);
        expect(find.byType(CreatePurchaseResultPage), findsOneWidget);

        // 価格を入力
        await tester.tap(find.byWidgetPredicate((widget) =>
            widget is PickerFormField &&
            widget.labelText == AppLocalizations.of(context)!.commonPrice));
        await tester.pumpAndSettle();
        await tester.tap(find.text(price.toString()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppLocalizations.of(context)!.commonOk));
        await tester.pumpAndSettle();

        // 購入日を入力
        await tester.tap(find.byWidgetPredicate((widget) =>
            widget is PickerFormField &&
            widget.labelText ==
                AppLocalizations.of(context)!.commonPurchaseDate));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppLocalizations.of(context)!.commonOk));
        await tester.pumpAndSettle();

        await tester
            .tap(find.text(AppLocalizations.of(context)!.commonRegister));
        await tester.pumpAndSettle();

        verify(
          createPurchaseResultUseCase.call(
            CreatePurchaseResultUseCaseParams(
                commodity: commodity,
                shop: shop,
                price: price,
                quantity: quantity,
                purchaseDate: purchaseDate),
          ),
        ).called(1);

        expect(find.byType(CreatePurchaseResultPage), findsNothing);
      });

      testWidgets('登録処理で問題が発生した場合、エラーメッセージが表示されること',
          (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());

        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([commodity]));
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop]));
        when(createPurchaseResultUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(
            CreatePurchaseResultPage(
              initialCommodity: null,
            ),
            overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(CreatePurchaseResultPage);

        // 商品選択
        await tester.tap(find.byWidgetPredicate((widget) =>
            widget is PickerFormField &&
            widget.labelText == AppLocalizations.of(context)!.commonCommodity));
        await tester.pumpAndSettle();
        await tester.tap(find.text(commodity.name));
        await tester.pumpAndSettle();

        // 店舗選択
        await tester.tap(find.byWidgetPredicate((widget) =>
            widget is PickerFormField &&
            widget.labelText == AppLocalizations.of(context)!.commonShop));
        await tester.pumpAndSettle();
        await tester.tap(find.text(shop.name));
        await tester.pumpAndSettle();
        // 価格を入力
        await tester.tap(find.byWidgetPredicate((widget) =>
            widget is PickerFormField &&
            widget.labelText == AppLocalizations.of(context)!.commonPrice));
        await tester.pumpAndSettle();
        await tester.tap(find.text(price.toString()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppLocalizations.of(context)!.commonOk));
        await tester.pumpAndSettle();

        await tester
            .tap(find.text(AppLocalizations.of(context)!.commonRegister));
        await tester.pumpAndSettle();

        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);

        expect(find.byType(CreatePurchaseResultPage), findsOneWidget);
      });
    });

    group('余白タップ', () {
      testWidgets('入力Widget以外をタップできること', (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([commodity]));

        await tester.pumpAppWidget(
            CreatePurchaseResultPage(
              initialCommodity: null,
            ),
            overrides);
        await tester.pumpAndSettle();

        await tester.tap(find.byType(Scaffold));
      });
    });
  });
}
