import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/purchase_result_sort_type.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/delete_purchase_result_by_id_use_case.dart';
import 'package:compare_prices/domain/usecases/get_purchase_results_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_purchase_results_use_case.dart';
import 'package:compare_prices/ui/assets/color/app_colors.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/drawer/app_drawer.dart';
import 'package:compare_prices/ui/purchase_result/list/purchase_result_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../helper.dart';
import '../../../mocks/generate.mocks.dart';

void main() {
  group('PurchaseResultListPage', () {
    late MockGetPurchaseResultsUseCase getPurchaseResultsUseCase;
    late MockSortPurchaseResultsUseCase sortPurchaseResultsUseCase;
    late MockDeletePurchaseResultByIdUseCase deletePurchaseResultByIdUseCase;

    late List<Override> overrides;

    final commodity1 = Commodity.create("ca", QuantityType.count());
    final commodity2 = Commodity.create("cb", QuantityType.count());
    final commodity3 = Commodity.create("cc", QuantityType.count());

    final shop1 = Shop.createByName("shopName1");
    final shop2 = Shop.createByName("shopName2");
    final shop3 = Shop.createByName("shopName3");

    final purchaseResult1 = PurchaseResult(
      id: "1",
      commodity: commodity1,
      shop: shop1,
      price: 100,
      quantity: 2,
      purchaseDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final purchaseResult2 = PurchaseResult(
      id: "2",
      commodity: commodity2,
      shop: shop2,
      price: 150,
      quantity: 1,
      purchaseDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final purchaseResult3 = PurchaseResult(
      id: "3",
      commodity: commodity3,
      shop: shop3,
      price: 200,
      quantity: 4,
      purchaseDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final basePurchaseResults = [
      purchaseResult1,
      purchaseResult2,
      purchaseResult3
    ];

    setUp(() {
      getPurchaseResultsUseCase = MockGetPurchaseResultsUseCase();
      sortPurchaseResultsUseCase = MockSortPurchaseResultsUseCase();
      deletePurchaseResultByIdUseCase = MockDeletePurchaseResultByIdUseCase();

      overrides = [
        getPurchaseResultsUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetPurchaseResultsUseCase>(
              (ref) => getPurchaseResultsUseCase),
        ),
        sortPurchaseResultsUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<SortPurchaseResultsUseCase>(
              (ref) => sortPurchaseResultsUseCase),
        ),
        deletePurchaseResultByIdUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<DeletePurchaseResultByIdUseCase>(
              (ref) => deletePurchaseResultByIdUseCase),
        )
      ];
    });

    group('初期状態', () {
      testWidgets('履歴が存在しない場合、存在しない旨のメッセージが表示されること',
          (WidgetTester tester) async {
        when(getPurchaseResultsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([]));
        when(sortPurchaseResultsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([]));

        await tester.pumpAppWidget(PurchaseResultListPage(), overrides);

        await tester.pumpAndSettle();

        final context = tester.getContext(PurchaseResultListPage);

        expect(
            find.text(AppLocalizations.of(context)!.purchaseResultListNoData),
            findsOneWidget);
      });

      testWidgets('履歴が存在する場合、リスト表示されること', (WidgetTester tester) async {
        when(getPurchaseResultsUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(basePurchaseResults));
        when(sortPurchaseResultsUseCase.call(any)).thenAnswer(
            (realInvocation) => Result.success(basePurchaseResults));

        await tester.pumpAppWidget(PurchaseResultListPage(), overrides);

        await tester.pumpAndSettle();
        expect(find.text(purchaseResult1.shop.name), findsOneWidget);
        expect(find.text(purchaseResult2.shop.name), findsOneWidget);
        expect(find.text(purchaseResult3.shop.name), findsOneWidget);

        // ソートアイコンタップ
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pumpAndSettle();

        final context = tester.getContext(PurchaseResultListPage);

        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .purchaseResultListSortByNewestPurchaseDate),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .purchaseResultListSortByOldestPurchaseDate),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .purchaseResultListSortByNewestCreatedAt),
            findsOneWidget);
      });

      testWidgets('履歴取得時に問題が発生した場合、エラーメッセージが表示されること',
          (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());

        when(getPurchaseResultsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));
        when(sortPurchaseResultsUseCase.call(any)).thenAnswer(
            (realInvocation) => Result.success(basePurchaseResults));

        await tester.pumpAppWidget(PurchaseResultListPage(), overrides);

        final context = tester.getContext(PurchaseResultListPage);

        await tester.pump();
        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);
      });
    });
    group('ソート', () {
      testWidgets('ソート順変更時、ソート・絞り込み・ソート処理が走ること', (WidgetTester tester) async {
        when(getPurchaseResultsUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(basePurchaseResults));
        when(sortPurchaseResultsUseCase.call(any)).thenAnswer(
            (realInvocation) => Result.success(basePurchaseResults));

        await tester.pumpAppWidget(PurchaseResultListPage(), overrides);
        await tester.pump();

        final context = tester.getContext(PurchaseResultListPage);

        // ソート順変更
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppLocalizations.of(context)!
            .purchaseResultListSortByNewestCreatedAt));
        await tester.pump();

        // 文字色が変わることを確認
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pump();
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .purchaseResultListSortByNewestCreatedAt),
            findsOneWidget);

        // 処理が呼ばれることを確認
        verify(sortPurchaseResultsUseCase.call(SortPurchaseResultsUseCaseParams(
            purchaseResults: basePurchaseResults,
            sortType: PurchaseResultSortType.newestCreatedAt())));
      });
    });

    group('削除', () {
      testWidgets('確認メッセージキャンセルで削除処理が行われないこと', (WidgetTester tester) async {
        when(getPurchaseResultsUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([purchaseResult1]));
        when(sortPurchaseResultsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([purchaseResult1]));
        when(deletePurchaseResultByIdUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(() {}));

        await tester.pumpAppWidget(PurchaseResultListPage(), overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(PurchaseResultListPage);

        // 削除確認メッセージ表示
        await tester.drag(
            find.text(purchaseResult1.shop.name), Offset(-500.0, 0.0));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // 確認メッセージでキャンセル
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonCancel),
        );
        await tester.pumpAndSettle();

        verifyNever(deletePurchaseResultByIdUseCase.call(any));
      });

      testWidgets('確認メッセージOKで削除処理が行われること', (WidgetTester tester) async {
        when(getPurchaseResultsUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([purchaseResult1]));
        when(sortPurchaseResultsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([purchaseResult1]));
        when(deletePurchaseResultByIdUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(() {}));

        await tester.pumpAppWidget(PurchaseResultListPage(), overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(PurchaseResultListPage);

        // 削除確認メッセージ表示
        await tester.drag(
            find.text(purchaseResult1.shop.name), Offset(-500.0, 0.0));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // 確認メッセージOK
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonOk),
        );
        await tester.pumpAndSettle();

        verify(deletePurchaseResultByIdUseCase.call(purchaseResult1.id))
            .called(1);
      });

      testWidgets('削除処理で問題が発生した際にエラーが表示されること', (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());
        when(getPurchaseResultsUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([purchaseResult1]));
        when(sortPurchaseResultsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([purchaseResult1]));
        when(deletePurchaseResultByIdUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(PurchaseResultListPage(), overrides);
        await tester.pumpAndSettle();

        final context = tester.getContext(PurchaseResultListPage);

        // 削除確認メッセージ表示
        await tester.drag(
            find.text(purchaseResult1.shop.name), Offset(-500.0, 0.0));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // 確認メッセージOK
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonOk),
        );
        await tester.pumpAndSettle();

        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);
        verify(deletePurchaseResultByIdUseCase.call(purchaseResult1.id))
            .called(1);
      });
    });

    group('メニュー', () {
      testWidgets('メニューを表示できること', (WidgetTester tester) async {
        when(getPurchaseResultsUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success([purchaseResult1]));
        when(sortPurchaseResultsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([purchaseResult1]));

        await tester.pumpAppWidget(PurchaseResultListPage(), overrides);
        await tester.pump();

        final context = tester.getContext(PurchaseResultListPage);

        // メニュータップ
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // メニュー上の表示状態を確認
        expect(find.byType(AppDrawer), findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data == AppLocalizations.of(context)!.commonHistory),
            findsOneWidget);
      });
    });
  });
}
