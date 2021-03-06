import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/ui/common/extensions/datetime_extensions.dart';
import 'package:compare_prices/ui/common/extensions/int_extensions.dart';
import 'package:compare_prices/ui/common/extensions/show_dialog_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PurchaseResultRow extends HookWidget {
  final PurchaseResult _purchaseResult;

  final Function() _onDelete;

  const PurchaseResultRow(this._purchaseResult, this._onDelete) : super();

  @override
  Widget build(context) {
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
                    .purchaseResultRowDeleteConfirmation(
                        _purchaseResult.commodity.name,
                        _purchaseResult.shop.name,
                        _purchaseResult.price.currency(context),
                        _purchaseResult.quantity.toString(),
                        _purchaseResult.commodity.quantityType.suffix(context),
                        _purchaseResult.purchaseDate
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _purchaseResult.commodity.name,
                style: Theme.of(context).textTheme.subtitle1,
                softWrap: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(
                        Icons.storefront_outlined,
                        size: 17,
                      ),
                    ),
                    Text(
                      _purchaseResult.shop.name,
                      style: Theme.of(context).textTheme.subtitle2,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _purchaseResult.price.currency(context),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      AppLocalizations.of(context)!.commonQuantityWithSuffix(
                          _purchaseResult.quantity.toString(),
                          _purchaseResult.commodity.quantityType
                              .suffix(context)),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      AppLocalizations.of(context)!.commonPurchaseDate,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  Text(
                    _purchaseResult.purchaseDate.toFormattedString(context),
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              // Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
