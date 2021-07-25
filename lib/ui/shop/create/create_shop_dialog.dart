import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'create_shop_dialog_view_model.dart';

class CreateShopDialog extends HookWidget {
  const CreateShopDialog({Key? key}) : super(key: key);

  @override
  Widget build(context) {
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

    final _formKey = useMemoized(() => GlobalKey<FormState>());

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.createShopTitle),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
              errorText: happenedExceptionType?.errorMessage(context),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
              labelText: AppLocalizations.of(context)!.commonShopName),
          onChanged: viewModel.updateName,
          validator: (_) => viewModel.validateName(context),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.commonCancel)),
        TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                viewModel.createShop();
              }
            },
            child: Text(AppLocalizations.of(context)!.commonAdd)),
      ],
    );
  }
}
