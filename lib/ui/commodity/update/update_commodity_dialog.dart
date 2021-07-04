import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/ui/common/text_edit_dialog.dart';
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

    final viewModel = useProvider(provider.notifier);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });

        viewModel.onCommodityUpdated.stream.listen((commodity) {
          Navigator.pop(context, commodity);
        });
      });

      return () => {};
    }, const []);

    return TextEditDialog(
      title: AppLocalizations.of(context)!.updateCommodityTitle,
      initialText: commodity.name,
      labelText: AppLocalizations.of(context)!.commonCommodityName,
      submitText: AppLocalizations.of(context)!.commonUpdate,
      onTextChanged: viewModel.updateName,
      onSubmitted: viewModel.updateCommodity,
    );
  }
}
