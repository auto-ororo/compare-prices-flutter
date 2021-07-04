import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/main.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/number_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/extensions/datetime_extensions.dart';
import '../../common/picker_form_field.dart';
import 'create_purchase_result_page_view_model.dart';

class CreatePurchaseResultPage extends HookWidget {
  final Commodity? initialCommodity;

  const CreatePurchaseResultPage({Key? key, this.initialCommodity})
      : super(key: key);

  @override
  Widget build(context) {
    final provider =
        createPurchaseResultPageViewModelProvider(initialCommodity);
    final selectedCommodity =
        useProvider(provider.select((value) => value.selectedCommodity));
    final selectedShop =
        useProvider(provider.select((value) => value.selectedShop));
    final count = useProvider(provider.select((value) => value.count));
    final purchaseDate =
        useProvider(provider.select((value) => value.purchaseDate));
    final viewModel = useProvider(provider.notifier);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.onExceptionHappened.stream.listen((type) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(type.errorMessage(context))),
          );
        });

        viewModel.onPurchaseResultCreated.stream.listen((_) {
          Navigator.of(context).pop();
        });
      });

      return () {};
    }, const []);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.createPurchaseResultTitle),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: AbsorbPointer(
                          absorbing: initialCommodity != null,
                          child: PickerFormField(
                            labelText:
                                AppLocalizations.of(context)!.commonCommodity,
                            text: initialCommodity?.name ??
                                selectedCommodity?.name ??
                                "",
                            onTap: () async {
                              final selectedCommodity =
                                  await Navigator.of(context)
                                      .pushNamed<Commodity>(
                                          RouteName.selectCommodityPage);
                              viewModel
                                  .updateSelectedCommodity(selectedCommodity);
                            },
                            validator: viewModel.validateCommodity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: PickerFormField(
                          labelText: AppLocalizations.of(context)!.commonShop,
                          text: selectedShop?.name ?? "",
                          onTap: () async {
                            final selectedShop = await Navigator.of(context)
                                .pushNamed<Shop>(RouteName.selectShopPage);

                            viewModel.updateSelectedShop(selectedShop);
                          },
                          validator: viewModel.validateShop,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Flexible(
                              child: PickerFormField(
                                textAlign: TextAlign.end,
                                labelText: AppLocalizations.of(context)!
                                    .commonQuantity,
                                text: count.toString(),
                                onTap: () async {
                                  final value = await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) {
                                        return NumberPickerDialog(
                                          title: AppLocalizations.of(context)!
                                              .createPurchaseResultSelectQuantity,
                                          minimum: 1,
                                          maximum: 100,
                                          initialNumber: count,
                                          unitText:
                                              AppLocalizations.of(context)!
                                                  .commonUnit,
                                        );
                                      });

                                  viewModel.updateCount(value);
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                AppLocalizations.of(context)!.commonUnit,
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Flexible(
                              child: TextFormField(
                                textAlign: TextAlign.end,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8),
                                    labelText: AppLocalizations.of(context)!
                                        .createPurchaseResultTotalPrice),
                                validator: (_) => viewModel.validatePrice(),
                                onChanged: (value) =>
                                    viewModel.updatePrice(value),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                AppLocalizations.of(context)!.commonCurrency,
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: PickerFormField(
                            textAlign: TextAlign.end,
                            labelText: AppLocalizations.of(context)!
                                .commonPurchaseDate,
                            text: purchaseDate.toFormattedString(),
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 3600)));

                              viewModel.updatePurchaseDate(pickedDate);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context)!.commonRegister,
                          style: TextStyle(fontSize: 25)),
                    ),
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        viewModel.submit();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
