import 'package:compare_prices/domain/entities/bottom_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class BottomPriceRow extends StatelessWidget {
  const BottomPriceRow(this._bottomPrice, this._onTap) : super();

  final BottomPrice _bottomPrice;

  final void Function() _onTap;

  @override
  Widget build(BuildContext context) {
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
                      Text(
                        _bottomPrice.commodity.name,
                        softWrap: true,
                        style: Theme.of(context).textTheme.headline5,
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
                                  _bottomPrice.price.toString(),
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Flexible(
                                  child: Text(
                                    _bottomPrice.mostInexpensiveShop.name,
                                    softWrap: true,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '最終購入日',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(_bottomPrice.purchaseDate),
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: 16,
                )
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