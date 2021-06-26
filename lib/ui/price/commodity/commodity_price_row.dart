import 'package:compare_prices/assets/color/custom_colors.dart';
import 'package:compare_prices/assets/fonts/custom_icons.dart';
import 'package:compare_prices/domain/entities/commodity_price.dart';
import 'package:compare_prices/ui/common/extensions/datetime_extensions.dart';
import 'package:compare_prices/ui/common/extensions/int_extensions.dart';
import 'package:compare_prices/ui/common/extensions/show_dialog_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CommodityPriceRow extends HookWidget {
  final CommodityPrice _commodityPrice;

  final Function() _onDelete;

  const CommodityPriceRow(this._commodityPrice, this._onDelete) : super();
  @override
  Widget build(BuildContext context) {
    final Color crownColor;

    switch (_commodityPrice.rank) {
      case 1:
        crownColor = CustomColors.gold;
        break;
      case 2:
        crownColor = CustomColors.silver;
        break;
      case 3:
        crownColor = CustomColors.bronze;
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
                message: "店舗:${_commodityPrice.shop.name}"
                    "\n価格:${_commodityPrice.price.currency()}"
                    "\n購入日:${_commodityPrice.purchaseDate.toFormattedString()}"
                    "\nの購買履歴を削除しますか？",
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
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18))),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: Text(_commodityPrice.price.currency(),
                                  style: TextStyle(fontSize: 16)),
                            ),
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
