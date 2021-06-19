// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/repositories/example_repository.dart';
import 'package:compare_prices/ui/example/example_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'example_page_widget_test.mocks.dart';

@GenerateMocks([ExampleRepository])
void main() {
  group('ExamplePage', () {
    testWidgets('counter', (WidgetTester tester) async {
      final repository = MockExampleRepository();

      // Build our app and trigger a frame.
      await tester.pumpWidget(ProviderScope(
          overrides: [
            exampleRepositoryProvider.overrideWithProvider(
                Provider.autoDispose<ExampleRepository>((ref) => repository)),
          ],
          child: MaterialApp(
            home: ExamplePage(),
          )));

      expect(find.text('0'), findsOneWidget);

      final tapTexts = ['+1', '+1', '-1', '-1', '-1', '-1'];

      await Future.forEach(tapTexts, (String element) async {
        await tester.tap(find.text(element));
      });

      await tester.pump();
      expect(find.text('-2'), findsOneWidget);

      await tester.tap(find.text('clear'));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('fetch word', (WidgetTester tester) async {
      final repository = MockExampleRepository();

      // Build our app and trigger a frame.
      await tester.pumpWidget(ProviderScope(
          overrides: [
            exampleRepositoryProvider.overrideWithProvider(
                Provider.autoDispose<ExampleRepository>((ref) => repository)),
          ],
          child: MaterialApp(
            home: ExamplePage(),
          )));

      when(repository.getExampleWord())
          .thenAnswer((realInvocation) => Future.value(Result.success("hoge")));

      await tester.tap(find.text('Fetch Word'));
      await tester.pump();
      expect(find.text('hoge'), findsOneWidget);

      await tester.tap(find.text('clear Word'));
      await tester.pump();
      expect(find.text('hoge'), findsNothing);
    });
  });
}
