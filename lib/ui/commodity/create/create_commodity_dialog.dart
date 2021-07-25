import 'package:compare_prices/domain/entities/quantity.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'create_commodity_dialog_view_model.dart';

class CreateCommodityDialog extends HookWidget {
  const CreateCommodityDialog({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    final quantity = useProvider(createCommodityDialogViewModelProvider
        .select((value) => value.quantity));
    final happenedExceptionType = useProvider(
        createCommodityDialogViewModelProvider
            .select((value) => value.happenedExceptionType));
    final viewModel =
        useProvider(createCommodityDialogViewModelProvider.notifier);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.onCommodityCreated.stream.listen((_) {
          Navigator.pop(context);
        });
      });

      return () => {};
    }, const []);

    final _formKey = useMemoized(() => GlobalKey<FormState>());

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.createCommodityTitle),
      content: Form(
        key: _formKey,
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  errorText: happenedExceptionType?.errorMessage(context),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                  labelText: AppLocalizations.of(context)!.commonCommodityName),
              onChanged: viewModel.updateName,
              validator: (_) => viewModel.validateName(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: DropdownButtonFormField<Quantity>(
                  isExpanded: true,
                  value: quantity,
                  onChanged: (q) => viewModel.updateQuantity(q),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8),
                      labelText:
                          AppLocalizations.of(context)!.commonQuantityUnit),
                  items: Quantity.values()
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Container(
                              width: double.infinity,
                              child: Text(
                                e.label(context),
                                textAlign: TextAlign.end,
                              ))))
                      .toList()),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.commonCancel)),
        TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                viewModel.createCommodity();
              }
            },
            child: Text(AppLocalizations.of(context)!.commonAdd)),
      ],
    );
  }
}
