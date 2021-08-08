import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:compare_prices/domain/repositories/infrastructure_config_repository.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';
import 'package:compare_prices/ui/app_theme.dart';
import 'package:compare_prices/ui/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@isTest
void testWithBuildContext(String description, Function(BuildContext) func) {
  testWidgets(description, (WidgetTester tester) async {
    await tester.pumpWidget(
      Localizations(
        delegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale('ja', ''),
        child: Builder(
          builder: (BuildContext context) {
            func(context);
            // The builder function must return a widget.
            return Placeholder();
          },
        ),
      ),
    );
  });
}

ProviderContainer getDisposableProviderContainer({
  CommodityRepository? commodityRepository = null,
  ShopRepository? shopRepository = null,
  PurchaseResultRepository? purchaseResultRepository = null,
  InfrastructureConfigRepository? infrastructureConfigRepository = null,
}) {
  final overrideList = <Override>[];

  if (commodityRepository != null) {
    overrideList.add(commodityRepositoryProvider.overrideWithProvider(
      Provider.autoDispose<CommodityRepository>((ref) => commodityRepository),
    ));
  }
  if (shopRepository != null) {
    overrideList.add(shopRepositoryProvider.overrideWithProvider(
      Provider.autoDispose<ShopRepository>((ref) => shopRepository),
    ));
  }
  if (purchaseResultRepository != null) {
    overrideList.add(purchaseResultRepositoryProvider.overrideWithProvider(
      Provider.autoDispose<PurchaseResultRepository>(
          (ref) => purchaseResultRepository),
    ));
  }
  if (infrastructureConfigRepository != null) {
    overrideList
        .add(infrastructureConfigRepositoryProvider.overrideWithProvider(
      Provider.autoDispose<InfrastructureConfigRepository>(
          (ref) => infrastructureConfigRepository),
    ));
  }
  final container = ProviderContainer(overrides: overrideList);
  addTearDown(container.dispose);

  return container;
}

extension ResultExtensions on Result {
  Exception get exception {
    return when(
      success: (data) => throw Error(),
      failure: (e) => e,
    );
  }
}

extension WidgetTesterExtensions on WidgetTester {
  Future<void> pumpAppWidget(
      Widget widget, List<Override>? overrideProviders) async {
    // 標準的なiphoneサイズを設定
    binding.window.physicalSizeTestValue = Size(1242, 2268);

    await pumpWidget(
      ProviderScope(
        overrides: overrideProviders ?? [],
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          supportedLocales: [
            const Locale('ja', ''),
          ],
          onGenerateRoute: route,
          home: widget,
        ),
      ),
    );
  }

  BuildContext getContext(Type rootWidgetType) {
    return element(find.byWidgetPredicate(
        (Widget widget) => widget.runtimeType == rootWidgetType));
  }
}
