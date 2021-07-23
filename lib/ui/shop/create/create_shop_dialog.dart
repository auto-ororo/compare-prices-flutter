import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/text_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'create_shop_dialog_view_model.dart';

class CreateShopDialog extends HookWidget {
  const CreateShopDialog({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    final name = useProvider(
        createShopDialogViewModelProvider.select((value) => value.name));
    final happenedExceptionType = useProvider(createShopDialogViewModelProvider
        .select((value) => value.happenedExceptionType));

    final viewModel = useProvider(createShopDialogViewModelProvider.notifier);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.onShopCreated.stream.listen((_) {
          Navigator.pop(context);
        });
      });

      return () => {};
    }, const []);

    return TextEditDialog(
      title: AppLocalizations.of(context)!.createShopTitle,
      labelText: AppLocalizations.of(context)!.commonShopName,
      errorText: happenedExceptionType?.errorMessage(context),
      submitText: AppLocalizations.of(context)!.commonAdd,
      initialText: name,
      onTextChanged: viewModel.updateName,
      onSubmitted: viewModel.createShop,
    );
  }
}
