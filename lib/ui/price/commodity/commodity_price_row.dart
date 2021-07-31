import 'package:compare_prices/domain/entities/commodity_price.dart';
import 'package:compare_prices/domain/entities/quantity_type.dart';
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

  static const _widgetSize = 32.0;

  const CommodityPriceRow(this._commodityPrice, this._onDelete) : super();

  @override
  Widget build(context) {
    final Widget rankWidget;

    switch (_commodityPrice.rank) {
      case 1:
        rankWidget = Image.asset(
          "lib/ui/assets/image/crown_gold.png",
          width: _widgetSize,
          height: _widgetSize,
        );
        break;
      case 2:
        rankWidget = Image.asset(
          "lib/ui/assets/image/crown_silver.png",
          width: _widgetSize,
          height: _widgetSize,
        );
        break;
      case 3:
        rankWidget = Image.asset(
          "lib/ui/assets/image/crown_bronze.png",
          width: _widgetSize,
          height: _widgetSize,
        );
        break;
      default:
        rankWidget = SizedBox(
          width: _widgetSize,
          height: _widgetSize,
        );
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
                        _commodityPrice.totalPrice.currency(context),
                        _commodityPrice.quantity.toString(),
                        _commodityPrice.commodity.quantityType.suffix(context),
                        _commodityPrice.purchaseDate
                            .toFormattedString(context)),
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
                      padding: const EdgeInsets.only(right: 8),
                      child: rankWidget),
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
                                _commodityPrice.totalPrice.currency(context),
                                style: Theme.of(context).textTheme.subtitle1,
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
                                        _commodityPrice.unitPrice
                                            .currency(context),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
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
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
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
                              _commodityPrice.purchaseDate
                                  .toFormattedString(context),
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
