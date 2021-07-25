import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/quantity.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'update_commodity_dialog_view_model.dart';

class UpdateCommodityDialog extends HookWidget {
  final Commodity commodity;

  const UpdateCommodityDialog({Key? key, required this.commodity})
      : super(key: key);

  @override
  Widget build(context) {
    final provider = updateCommodityDialogViewModelProvider(this.commodity);
    final commodity = useProvider(provider.select((value) => value.commodity));
    final happenedExceptionType =
        useProvider(provider.select((value) => value.happenedExceptionType));

    final viewModel = useProvider(provider.notifier);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.onCommodityUpdated.stream.listen((commodity) {
          Navigator.pop(context, commodity);
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
              initialValue: commodity.name,
              onChanged: viewModel.updateName,
              validator: (_) => viewModel.validateName(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                enabled: false,
                textAlign: TextAlign.end,
                initialValue: commodity.quantity.label(context),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    labelText:
                        AppLocalizations.of(context)!.commonQuantityUnit),
              ),
            ),
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
                viewModel.updateCommodity();
              }
            },
            child: Text(AppLocalizations.of(context)!.commonUpdate)),
      ],
    );
  }
}
