import 'package:compare_prices/domain/entities/commodity_price.dart';
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
                        _commodityPrice.unitPrice.currency(),
                        _commodityPrice.purchaseDate.toFormattedString()),
                onOk: _onDelete);
          },
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(CustomIcons.crown, size: 16, color: crownColor),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(_commodityPrice.shop.name,
                              softWrap: true, style: TextStyle(fontSize: 18))),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(_commodityPrice.totalPrice.currency(),
                                style: TextStyle(fontSize: 16)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .commonUnitPerCount(
                                        _commodityPrice.count > 1
                                            ? _commodityPrice.count.toString()
                                            : ""),
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            if (_commodityPrice.count > 1)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                        _commodityPrice.unitPrice.currency(),
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .commonUnitPerPiece,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                ],
                              ),
                            Spacer(),
                            Text(
                              _commodityPrice.purchaseDate.toFormattedString(),
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 2,
            )
          ],
        ),
      ),
    );
  }
}
