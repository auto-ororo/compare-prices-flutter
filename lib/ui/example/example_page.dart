import 'package:compare_prices/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'example_page_view_model.dart';

class ExamplePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useProvider(
        examplePageViewModelProvider.select((value) => value.counter));
    final fetchedWord = useProvider(
        examplePageViewModelProvider.select((value) => value.fetchedWord));
    final viewModel = useProvider(examplePageViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  counter.toString(),
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                    onPressed: viewModel.incrementCounter, child: Text("+1")),
                OutlinedButton(
                    onPressed: viewModel.decrementCounter, child: Text("-1")),
                OutlinedButton(
                    onPressed: viewModel.clearCounter, child: Text("clear")),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: viewModel.clearWord, child: Text("clear Word")),
                OutlinedButton(
                    onPressed: viewModel.fetchWordFromRepository,
                    child: Text("Fetch Word")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    fetchedWord,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(RouteName.bottomPriceListPage);
                    },
                    child: Text("底値リストへ")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
