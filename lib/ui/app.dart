import 'package:compare_prices/domain/usecases/initialize_app_use_case.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:compare_prices/ui/app_theme.dart';
import 'package:compare_prices/ui/assets/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'route.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(context) {
    return ProviderScope(child: _App());
  }
}

class _App extends HookWidget {
  @override
  Widget build(context) {
    final useCase = useProvider(initializeAppUseCaseProvider);

    final initializeResult = useMemoized(() => useCase(NoParam()));
    final snapShot = useFuture(initializeResult);

    if (snapShot.hasData) {
      return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ja', ''),
        ],
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        initialRoute: RouteName.bottomPriceListPage,
        onGenerateRoute: route,
      );
    } else {
      return Container(
        decoration: BoxDecoration(color: AppColors.primary),
      );
    }
  }
}
