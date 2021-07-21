import 'package:compare_prices/domain/entities/bottom_price.dart';
import 'package:compare_prices/ui/common/extensions/datetime_extensions.dart';
import 'package:compare_prices/ui/common/extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomPriceRow extends StatelessWidget {
  const BottomPriceRow(this._bottomPrice, this._onTap) : super();

  final BottomPrice _bottomPrice;

  final void Function() _onTap;

  @override
  Widget build(context) {
    return InkWell(
      onTap: _onTap,
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
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      _bottomPrice.mostInexpensiveShop.name,
                      softWrap: true,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Text(
                          _bottomPrice.unitPrice.currency(),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          AppLocalizations.of(context)!.commonUnitPerPiece,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            AppLocalizations.of(context)!
                                .commonLastPurchaseDate,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        Text(
                          _bottomPrice.purchaseDate.toFormattedString(),
                          style: Theme.of(context).textTheme.caption,
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
          Divider()
        ],
      ),
    );
  }
}
