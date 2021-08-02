import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/number_type.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/input_number_dialog/input_number_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/extensions/datetime_extensions.dart';
import '../../common/extensions/int_extensions.dart';
import '../../common/picker_form_field.dart';
import '../../route.dart';
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
    final price = useProvider(provider.select((value) => value.price));
    final purchaseDate =
        useProvider(provider.select((value) => value.purchaseDate));
    final viewModel = useProvider(provider.notifier);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    final quantityType =
        selectedCommodity?.quantityType ?? QuantityType.count();

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.onExceptionHappened.stream.listen((type) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(type.errorMessage(context))),
          );
        });

        if (initialCommodity != null) {
          viewModel.updateQuantity(initialCommodity!.quantityType.unit());
        }

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
                                          RouteName.commodityListPage,
                                          arguments: {
                                    ArgumentName.title:
                                        AppLocalizations.of(context)!
                                            .selectCommodityTitle,
                                    ArgumentName.isSelectable: true,
                                    ArgumentName.isFullscreenDialog: true
                                  });
                              viewModel.updateSelectedCommodityAndQuantity(
                                  selectedCommodity);
                            },
                            validator: () =>
                                viewModel.validateCommodity(context),
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
                                .pushNamed<Shop>(RouteName.shopListPage,
                                    arguments: {
                                  ArgumentName.title:
                                      AppLocalizations.of(context)!
                                          .selectShopTitle,
                                  ArgumentName.isSelectable: true,
                                  ArgumentName.isFullscreenDialog: true
                                });

                            viewModel.updateSelectedShop(selectedShop);
                          },
                          validator: () => viewModel.validateShop(context),
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
                                labelText: quantityType.label(context),
                                text: count.toString(),
                                onTap: () async {
                                  final value = await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) {
                                        return InputNumberDialog(
                                          title: quantityType.label(context),
                                          initialNumber: count,
                                          suffix: quantityType.suffix(context),
                                          numberType: NumberType.count(),
                                        );
                                      });

                                  viewModel.updateQuantity(value);
                                },
                                validator: () =>
                                    viewModel.validateCount(context),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                quantityType.suffix(context),
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
                              child: PickerFormField(
                                textAlign: TextAlign.end,
                                labelText:
                                    AppLocalizations.of(context)!.commonPrice,
                                text:
                                    price.currency(context, showSymbol: false),
                                onTap: () async {
                                  final value = await showDialog<int>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) {
                                        return InputNumberDialog(
                                          title: AppLocalizations.of(context)!
                                              .createPurchaseResultTotalPrice,
                                          initialNumber: price,
                                          numberType: NumberType.currency(),
                                        );
                                      });
                                  viewModel.updatePrice(value);
                                },
                                validator: () =>
                                    viewModel.validatePrice(context),
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
                            text: purchaseDate.toFormattedString(context),
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
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
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
