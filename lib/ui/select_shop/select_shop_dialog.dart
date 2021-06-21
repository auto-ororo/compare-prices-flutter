import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SelectShopDialog extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {});

      return () {};
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('店舗選択'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SearchTextField(
              controller: textEditingController,
              labelText: "店舗名",
              hintText: "店舗名を入力してください。",
              onChanged: (word) {
                print(word);
              },
            ),
          ),
        ],
      ),
    );
  }
}
