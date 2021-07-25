import 'package:compare_prices/domain/entities/commodity_price.dart';
import 'package:compare_prices/domain/entities/quantity_type.dart';
import 'package:compare_prices/ui/assets/color/app_colors.dart';
import 'package:compare_prices/ui/assets/fonts/custom_icons.dart';
import 'package:compare_prices/ui/common/extensions/datetime_extensions.dart';
import 'package:compare_prices/ui/common/extensions/int_extensions.dart';
import 'package:compare_prices/ui/common/extensions/show_dialog_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CommodityPriceRow extends HookWidget {
  final CommodityPrice _commodityPrice;

  final Function() _onDelete;

  const CommodityPriceRow(this._commodityPrice, this._onDelete) : super();
  @override
  Widget build(context) {
    final Color crownColor;

    switch (_commodityPrice.rank) {
      case 1:
        crownColor = AppColors.gold;
        break;
      case 2:
        crownColor = AppColors.silver;
        break;
      case 3:
        crownColor = AppColors.bronze;
        break;
      default:
        crownColor = Colors.transparent;
        break;
    }

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      secondaryActions: [
        IconSlideAction(
          color: Colors.redAccent,
          icon: Icons.delete,
          onTap: () async {
            await showConfirmDialog(
                context: context,
                message: AppLocalizations.of(context)!
                    .commodityPriceRowDeleteConfirmation(
                        _commodityPrice.shop.name,
                        _commodityPrice.totalPrice.currency(),
                        _commodityPrice.quantity.toString(),
                        _commodityPrice.commodity.quantityType.suffix(context),
                        _commodityPrice.purchaseDate.toFormattedString()),
                onOk: _onDelete);
          },
        ),
      ],
      child: Card(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(CustomIcons.crown, size: 16, color: crownColor),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _commodityPrice.shop.name,
                          softWrap: true,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _commodityPrice.totalPrice.currency(),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .commonQuantityWithSuffix(
                                          _commodityPrice.quantity.toString(),
                                          _commodityPrice.commodity.quantityType
                                              .suffix(context)),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                              if (!_commodityPrice.commodity.quantityType
                                  .isEqualToUnit(_commodityPrice.quantity))
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        _commodityPrice.unitPrice.currency(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .commonUnitWithSuffix(
                                          _commodityPrice.commodity.quantityType
                                              .unit()
                                              .toString(),
                                          _commodityPrice.commodity.quantityType
                                              .suffix(context),
                                        ),
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .commonPurchaseDate,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            Text(
                              _commodityPrice.purchaseDate.toFormattedString(),
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
