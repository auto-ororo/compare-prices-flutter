import 'package:compare_prices/di/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExamplePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(examplePageViewModelProvider);
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
                  state.counter.toString(),
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
                    state.fetchedWord,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
