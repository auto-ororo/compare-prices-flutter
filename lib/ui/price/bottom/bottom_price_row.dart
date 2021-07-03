import 'package:compare_prices/domain/entities/bottom_price.dart';
import 'package:compare_prices/ui/common/extensions/datetime_extensions.dart';
import 'package:compare_prices/ui/common/extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BottomPriceRow extends StatelessWidget {
  const BottomPriceRow(this._bottomPrice, this._onTap) : super();

  final BottomPrice _bottomPrice;

  final void Function() _onTap;

  @override
  Widget build(context) {
    return InkWell(
      onTap: _onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          _bottomPrice.commodity.name,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  _bottomPrice.unitPrice.currency(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: Text(
                                    "/個",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Text(
                                      _bottomPrice.mostInexpensiveShop.name,
                                      softWrap: true,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '最終購入日',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      _bottomPrice.purchaseDate.toFormattedString(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: 16,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Divider(
                height: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
