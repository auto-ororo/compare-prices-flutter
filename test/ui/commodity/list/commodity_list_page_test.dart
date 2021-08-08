import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/commodity_sort_type.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/create_commodity_use_case.dart';
import 'package:compare_prices/domain/usecases/delete_commodity_use_case.dart';
import 'package:compare_prices/domain/usecases/filter_commodities_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_commodities_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_commodities_use_case.dart';
import 'package:compare_prices/ui/assets/color/app_colors.dart';
import 'package:compare_prices/ui/commodity/create/create_commodity_dialog.dart';
import 'package:compare_prices/ui/commodity/list/commodity_list_page.dart';
import 'package:compare_prices/ui/commodity/update/update_commodity_dialog.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:compare_prices/ui/drawer/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../helper.dart';
import '../../../mocks/generate.mocks.dart';

void main() {
  group('CommodityListPage', () {
    late MockCreateCommodityUseCase createCommodityUseCase;
    late MockGetCommoditiesUseCase getCommoditiesUseCase;
    late MockDeleteCommodityUseCase deleteCommodityUseCase;
    late MockFilterCommoditiesByKeywordUseCase
        filterCommoditiesByKeywordUseCase;
    late MockSortCommoditiesUseCase sortCommoditiesUseCase;

    late List<Override> overrides;

    final title = "title";

    final commodity1 = Commodity.create("a", QuantityType.gram());
    final commodity2 = Commodity.create("b", QuantityType.gram());
    final commodity3 = Commodity.create("c", QuantityType.gram());

    final baseCommodities = [commodity1, commodity2, commodity3];

    setUp(() {
      createCommodityUseCase = MockCreateCommodityUseCase();
      getCommoditiesUseCase = MockGetCommoditiesUseCase();
      deleteCommodityUseCase = MockDeleteCommodityUseCase();
      filterCommoditiesByKeywordUseCase =
          MockFilterCommoditiesByKeywordUseCase();
      sortCommoditiesUseCase = MockSortCommoditiesUseCase();

      overrides = [
        createCommodityUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<CreateCommodityUseCase>(
              (ref) => createCommodityUseCase),
        ),
        getCommoditiesUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetCommoditiesUseCase>(
              (ref) => getCommoditiesUseCase),
        ),
        deleteCommodityUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<DeleteCommodityUseCase>(
              (ref) => deleteCommodityUseCase),
        ),
        filterCommoditiesByKeywordUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<FilterCommoditiesByKeywordUseCase>(
              (ref) => filterCommoditiesByKeywordUseCase),
        ),
        sortCommoditiesUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<SortCommoditiesUseCase>(
              (ref) => sortCommoditiesUseCase),
        ),
      ];

      when(createCommodityUseCase.call(any))
          .thenAnswer((realInvocation) async => Result.success(commodity1));
    });

    group('初期状態', () {
      testWidgets('商品が存在しない場合、検索欄が表示されず、データ登録を促すメッセージが表示されること',
          (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([]));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([]));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([]));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);

        final context = tester.getContext(CommodityListPage);

        expect(find.text(title), findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.commodityListNoData),
            findsOneWidget);
        expect(find.byType(SearchTextField), findsNothing);
      });

      testWidgets('商品が存在する場合、リスト表示されること', (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseCommodities));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);

        final context = tester.getContext(CommodityListPage);

        await tester.pump();
        expect(find.text(title), findsOneWidget);
        expect(find.text(commodity1.name), findsOneWidget);
        expect(find.text(commodity2.name), findsOneWidget);
        expect(find.text(commodity3.name), findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.commodityListNoData),
            findsNothing);
        expect(find.byType(SearchTextField), findsOneWidget);

        // ソートアイコンタップ
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pump();

        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .commodityListSortByNewestCreatedAt),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .commodityListSortByOldestCreatedAt),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!.commodityListSortByName),
            findsOneWidget);
      });

      testWidgets('商品取得時に問題が発生した場合、エラーメッセージが表示されること',
          (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());

        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);

        final context = tester.getContext(CommodityListPage);

        await tester.pump();
        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);
        expect(find.text(title), findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.commodityListNoData),
            findsOneWidget);
        expect(find.byType(SearchTextField), findsNothing);
      });
    });

    group('絞り込み', () {
      testWidgets('検索欄に文字入力時、絞り込み・ソート処理が走ること', (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseCommodities));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        // 名前入力
        await tester.enterText(find.byType(TextField), "a");
        await tester.pumpAndSettle(Duration(seconds: 1));

        verify(filterCommoditiesByKeywordUseCase.call(
            FilterCommoditiesByKeywordUseCaseParams(
                commodities: baseCommodities, keyword: "a")));
        verify(sortCommoditiesUseCase.call(SortCommoditiesUseCaseParams(
            commodities: baseCommodities,
            sortType: CommoditySortType.newestCreatedAt())));
      });
    });

    group('ソート', () {
      testWidgets('ソート順変更時、ソート・絞り込み・ソート処理が走ること', (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseCommodities));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(CommodityListPage);

        // ソート順変更
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pumpAndSettle();
        await tester.tap(
            find.text(AppLocalizations.of(context)!.commodityListSortByName));
        await tester.pump();

        // 文字色が変わることを確認
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pump();
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data ==
                    AppLocalizations.of(context)!.commodityListSortByName),
            findsOneWidget);

        // 処理が呼ばれることを確認
        verify(filterCommoditiesByKeywordUseCase.call(
            FilterCommoditiesByKeywordUseCaseParams(
                commodities: baseCommodities, keyword: "")));
        verify(sortCommoditiesUseCase.call(SortCommoditiesUseCaseParams(
            commodities: baseCommodities, sortType: CommoditySortType.name())));
      });
    });

    group('登録', () {
      testWidgets('選択可能フラグがtrueの場合、登録後画面が閉じること', (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseCommodities));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(CommodityListPage);

        // 追加
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        expect(find.byType(CreateCommodityDialog), findsOneWidget);

        // 名前入力
        await tester.enterText(find.byType(TextFormField), "a");

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pumpAndSettle();

        expect(find.byType(CommodityListPage), findsNothing);

        verify(getCommoditiesUseCase.call(any)).called(1);
      });

      testWidgets('選択可能フラグがfalseの場合、登録後画面が閉じず、再度商品取得処理が行われること',
          (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any)).thenAnswer(
            (realInvocation) async => Result.success(baseCommodities));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseCommodities));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: false), overrides);
        await tester.pump();

        final context = tester.getContext(CommodityListPage);

        // 追加
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.byType(CreateCommodityDialog), findsOneWidget);

        // 名前入力
        await tester.enterText(find.byType(TextFormField), "a");

        // 登録処理実行
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pumpAndSettle();

        expect(find.byType(CommodityListPage), findsOneWidget);

        verify(getCommoditiesUseCase.call(any)).called(2);
      });
    });

    group('編集', () {
      testWidgets('編集ダイアログを開け、ダイアログを閉じた後に再度商品取得処理が行われること',
          (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([commodity1]));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(CommodityListPage);

        // 編集ダイアログを表示
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonEdit),
        );
        await tester.pumpAndSettle();

        // 編集ダイアログで商品情報が表示
        expect(find.byType(UpdateCommodityDialog), findsOneWidget);
        expect(find.text(commodity1.name), findsNWidgets(2));
        expect(
            find.text(commodity1.quantityType.label(context)), findsOneWidget);

        // 編集ダイアログを閉じる
        await tester.tap(find.text(AppLocalizations.of(context)!.commonCancel));
        await tester.pumpAndSettle();
        expect(find.byType(UpdateCommodityDialog), findsNothing);

        verify(getCommoditiesUseCase.call(any)).called(2);
      });
    });

    group('削除', () {
      testWidgets('確認メッセージキャンセルで削除処理が行われないこと', (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([commodity1]));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(CommodityListPage);

        // 削除確認メッセージ表示
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonDelete),
        );
        await tester.pumpAndSettle();

        // 確認メッセージでキャンセル
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonCancel),
        );
        await tester.pumpAndSettle();

        verifyNever(deleteCommodityUseCase.call(any));
      });

      testWidgets('確認メッセージOKで削除処理が行われること', (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([commodity1]));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));
        when(deleteCommodityUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(() {}));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(CommodityListPage);

        // 削除確認メッセージ表示
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonDelete),
        );
        await tester.pumpAndSettle();

        // 確認メッセージでOK
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonOk),
        );
        await tester.pumpAndSettle();

        verify(deleteCommodityUseCase.call(commodity1)).called(1);
        verify(getCommoditiesUseCase.call(any)).called(2);
      });

      testWidgets('削除処理で問題が発生した際にエラーが表示されること', (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());

        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([commodity1]));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));
        when(deleteCommodityUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(CommodityListPage);

        // 削除確認メッセージ表示
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonDelete),
        );
        await tester.pumpAndSettle();

        // 確認メッセージでOK
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonOk),
        );
        await tester.pumpAndSettle();

        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);
        verify(deleteCommodityUseCase.call(commodity1)).called(1);
      });
    });

    group('選択', () {
      testWidgets('選択可能フラグがtrueの場合、商品タップで画面が閉じること',
          (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([commodity1]));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        // 商品タップ
        await tester.tap(find.text(commodity1.name));
        await tester.pumpAndSettle();

        expect(find.byType(CommodityListPage), findsNothing);
      });

      testWidgets('選択可能フラグがfalseの場合、商品タップで画面が閉じないこと',
          (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([commodity1]));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: false), overrides);
        await tester.pump();

        // 商品タップ
        await tester.tap(find.text(commodity1.name));
        await tester.pumpAndSettle();

        expect(find.byType(CommodityListPage), findsOneWidget);
      });
    });

    group('メニュー', () {
      testWidgets('選択可能フラグがtrueの場合、メニューバーが存在しないこと',
          (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([commodity1]));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        expect(find.byIcon(Icons.menu), findsNothing);
      });

      testWidgets('選択可能フラグがfalseの場合、メニューを表示できること', (WidgetTester tester) async {
        when(getCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([commodity1]));
        when(filterCommoditiesByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));
        when(sortCommoditiesUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([commodity1]));

        await tester.pumpAppWidget(
            CommodityListPage(title: title, isSelectable: false), overrides);
        await tester.pump();

        final context = tester.getContext(CommodityListPage);

        expect(find.byIcon(Icons.menu), findsOneWidget);

        // メニュータップ
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // メニュー上の表示状態を確認
        expect(find.byType(AppDrawer), findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data == AppLocalizations.of(context)!.commonCommodity),
            findsOneWidget);
      });
    });
  });
}
