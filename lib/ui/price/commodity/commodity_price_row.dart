import 'package:compare_prices/assets/color/custom_colors.dart';
import 'package:compare_prices/assets/fonts/custom_icons.dart';
import 'package:compare_prices/domain/entities/commodity_price.dart';
import 'package:compare_prices/ui/common/extensions/datetime_extensions.dart';
import 'package:compare_prices/ui/common/extensions/int_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CommodityPriceRow extends StatelessWidget {
  const CommodityPriceRow(this._commodityPrice) : super();

  final CommodityPrice _commodityPrice;

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

    return Container(
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
    );
  }
}
