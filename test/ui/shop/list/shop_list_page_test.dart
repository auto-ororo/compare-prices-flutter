import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/models/shop_sort_type.dart';
import 'package:compare_prices/domain/usecases/create_shop_by_name_use_case.dart';
import 'package:compare_prices/domain/usecases/delete_shop_use_case.dart';
import 'package:compare_prices/domain/usecases/filter_shops_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_shops_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_shops_use_case.dart';
import 'package:compare_prices/ui/assets/color/app_colors.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:compare_prices/ui/drawer/app_drawer.dart';
import 'package:compare_prices/ui/shop/create/create_shop_dialog.dart';
import 'package:compare_prices/ui/shop/list/shop_list_page.dart';
import 'package:compare_prices/ui/shop/update/update_shop_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../helper.dart';
import '../../../mocks/generate.mocks.dart';

void main() {
  group('ShopListPage', () {
    late MockCreateShopByNameUseCase createShopUseCase;
    late MockGetShopsUseCase getShopsUseCase;
    late MockDeleteShopUseCase deleteShopUseCase;
    late MockFilterShopsByKeywordUseCase filterShopsByKeywordUseCase;
    late MockSortShopsUseCase sortShopsUseCase;

    late List<Override> overrides;

    final title = "title";

    final shop1 = Shop.createByName("a");
    final shop2 = Shop.createByName("b");
    final shop3 = Shop.createByName("c");

    final baseShops = [shop1, shop2, shop3];

    setUp(() {
      createShopUseCase = MockCreateShopByNameUseCase();
      getShopsUseCase = MockGetShopsUseCase();
      deleteShopUseCase = MockDeleteShopUseCase();
      filterShopsByKeywordUseCase = MockFilterShopsByKeywordUseCase();
      sortShopsUseCase = MockSortShopsUseCase();

      overrides = [
        createShopByNameUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<CreateShopByNameUseCase>(
              (ref) => createShopUseCase),
        ),
        getShopsUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<GetShopsUseCase>((ref) => getShopsUseCase),
        ),
        deleteShopUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<DeleteShopUseCase>((ref) => deleteShopUseCase),
        ),
        filterShopsByKeywordUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<FilterShopsByKeywordUseCase>(
              (ref) => filterShopsByKeywordUseCase),
        ),
        sortShopsUseCaseProvider.overrideWithProvider(
          Provider.autoDispose<SortShopsUseCase>((ref) => sortShopsUseCase),
        ),
      ];

      when(createShopUseCase.call(any))
          .thenAnswer((realInvocation) async => Result.success(shop1));
    });

    group('????????????', () {
      testWidgets('??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);

        final context = tester.getContext(ShopListPage);

        expect(find.text(title), findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.shopListNoData),
            findsOneWidget);
        expect(find.byType(SearchTextField), findsNothing);
      });

      testWidgets('????????????????????????????????????????????????????????????', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(baseShops));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);

        final context = tester.getContext(ShopListPage);

        await tester.pump();
        expect(find.text(title), findsOneWidget);
        expect(find.text(shop1.name), findsOneWidget);
        expect(find.text(shop2.name), findsOneWidget);
        expect(find.text(shop3.name), findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.shopListNoData),
            findsNothing);
        expect(find.byType(SearchTextField), findsOneWidget);

        // ??????????????????????????????
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pump();

        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .shopListSortByNewestCreatedAt),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!
                        .shopListSortByOldestCreatedAt),
            findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data ==
                    AppLocalizations.of(context)!.shopListSortByName),
            findsOneWidget);
      });

      testWidgets('????????????????????????????????????????????????????????????????????????????????????????????????',
          (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());

        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);

        final context = tester.getContext(ShopListPage);

        await tester.pump();
        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);
        expect(find.text(title), findsOneWidget);
        expect(find.text(AppLocalizations.of(context)!.shopListNoData),
            findsOneWidget);
        expect(find.byType(SearchTextField), findsNothing);
      });
    });

    group('????????????', () {
      testWidgets('???????????????????????????????????????????????????????????????????????????', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(baseShops));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        // ????????????
        await tester.enterText(find.byType(TextField), "a");
        await tester.pumpAndSettle(Duration(seconds: 1));

        verify(filterShopsByKeywordUseCase.call(
            FilterShopsByKeywordUseCaseParams(shops: baseShops, keyword: "a")));
        verify(sortShopsUseCase.call(SortShopsUseCaseParams(
            shops: baseShops, sortType: ShopSortType.newestCreatedAt())));
      });
    });

    group('?????????', () {
      testWidgets('?????????????????????????????????????????????????????????????????????????????????', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(baseShops));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // ??????????????????
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pumpAndSettle();
        await tester
            .tap(find.text(AppLocalizations.of(context)!.shopListSortByName));
        await tester.pump();

        // ????????????????????????????????????
        await tester.tap(find.byIcon(Icons.swap_vert));
        await tester.pump();
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data ==
                    AppLocalizations.of(context)!.shopListSortByName),
            findsOneWidget);

        // ????????????????????????????????????
        verify(filterShopsByKeywordUseCase.call(
            FilterShopsByKeywordUseCaseParams(shops: baseShops, keyword: "")));
        verify(sortShopsUseCase.call(SortShopsUseCaseParams(
            shops: baseShops, sortType: ShopSortType.name())));
      });
    });

    group('??????', () {
      testWidgets('????????????????????????true?????????????????????????????????????????????', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(baseShops));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // ??????
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        expect(find.byType(CreateShopDialog), findsOneWidget);

        // ????????????
        await tester.enterText(find.byType(TextFormField), "a");

        // ??????????????????
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pumpAndSettle();

        expect(find.byType(ShopListPage), findsNothing);

        verify(getShopsUseCase.call(any)).called(1);
      });

      testWidgets('????????????????????????false???????????????????????????????????????????????????????????????????????????????????????',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(baseShops));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success(baseShops));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: false), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // ??????
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.byType(CreateShopDialog), findsOneWidget);

        // ????????????
        await tester.enterText(find.byType(TextFormField), "a");

        // ??????????????????
        await tester.tap(find.text(AppLocalizations.of(context)!.commonAdd));
        await tester.pumpAndSettle();

        expect(find.byType(ShopListPage), findsOneWidget);

        verify(getShopsUseCase.call(any)).called(2);
      });
    });

    group('??????', () {
      testWidgets('???????????????????????????????????????????????????????????????????????????????????????????????????????????????',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // ??????????????????????????????
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonEdit),
        );
        await tester.pumpAndSettle();

        // ?????????????????????????????????????????????
        expect(find.byType(UpdateShopDialog), findsOneWidget);
        expect(find.text(shop1.name), findsNWidgets(2));

        // ?????????????????????????????????
        await tester.tap(find.text(AppLocalizations.of(context)!.commonCancel));
        await tester.pumpAndSettle();
        expect(find.byType(UpdateShopDialog), findsNothing);

        verify(getShopsUseCase.call(any)).called(2);
      });
    });

    group('??????', () {
      testWidgets('???????????????????????????????????????????????????????????????????????????', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // ?????????????????????????????????
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonDelete),
        );
        await tester.pumpAndSettle();

        // ???????????????????????????????????????
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonCancel),
        );
        await tester.pumpAndSettle();

        verifyNever(deleteShopUseCase.call(any));
      });

      testWidgets('?????????????????????OK????????????????????????????????????', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(deleteShopUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success(() {}));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // ?????????????????????????????????
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonDelete),
        );
        await tester.pumpAndSettle();

        // ????????????????????????OK
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonOk),
        );
        await tester.pumpAndSettle();

        verify(deleteShopUseCase.call(shop1)).called(1);
        verify(getShopsUseCase.call(any)).called(2);
      });

      testWidgets('???????????????????????????????????????????????????????????????????????????', (WidgetTester tester) async {
        final exception = DomainException(ExceptionType.alreadyExists());

        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(deleteShopUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.failure(exception));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        // ?????????????????????????????????
        await tester.tap(find.byIcon(Icons.adaptive.more));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonDelete),
        );
        await tester.pumpAndSettle();

        // ????????????????????????OK
        await tester.tap(
          find.text(AppLocalizations.of(context)!.commonOk),
        );
        await tester.pumpAndSettle();

        expect(find.text(exception.exceptionType().errorMessage(context)),
            findsOneWidget);
        verify(deleteShopUseCase.call(shop1)).called(1);
      });
    });

    group('??????', () {
      testWidgets('????????????????????????true??????????????????????????????????????????????????????',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        // ???????????????
        await tester.tap(find.text(shop1.name));
        await tester.pumpAndSettle();

        expect(find.byType(ShopListPage), findsNothing);
      });

      testWidgets('????????????????????????false?????????????????????????????????????????????????????????',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: false), overrides);
        await tester.pump();

        // ???????????????
        await tester.tap(find.text(shop1.name));
        await tester.pumpAndSettle();

        expect(find.byType(ShopListPage), findsOneWidget);
      });
    });

    group('????????????', () {
      testWidgets('????????????????????????true??????????????????????????????????????????????????????',
          (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: true), overrides);
        await tester.pump();

        expect(find.byIcon(Icons.menu), findsNothing);
      });

      testWidgets('????????????????????????false????????????????????????????????????????????????', (WidgetTester tester) async {
        when(getShopsUseCase.call(any))
            .thenAnswer((realInvocation) async => Result.success([shop1]));
        when(filterShopsByKeywordUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));
        when(sortShopsUseCase.call(any))
            .thenAnswer((realInvocation) => Result.success([shop1]));

        await tester.pumpAppWidget(
            ShopListPage(title: title, isSelectable: false), overrides);
        await tester.pump();

        final context = tester.getContext(ShopListPage);

        expect(find.byIcon(Icons.menu), findsOneWidget);

        // ?????????????????????
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // ???????????????????????????????????????
        expect(find.byType(AppDrawer), findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.style?.color == AppColors.primary &&
                widget.data == AppLocalizations.of(context)!.commonShop),
            findsOneWidget);
      });
    });
  });
}
