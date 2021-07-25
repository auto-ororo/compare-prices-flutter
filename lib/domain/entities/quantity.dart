import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quantity.freezed.dart';

const _countId = "1";
const _gramId = "2";
const _milliliterId = "3";

const _countUnit = 1;
const _gramUnit = 100;
const _milliliterUnit = 100;

@freezed
class Quantity<T> with _$Quantity<T> {
  const factory Quantity.count() = _count;
  const factory Quantity.gram() = _gram;
  const factory Quantity.milliliter() = _milliliter;

  static Quantity getTypeById(String id) {
    switch (id) {
      case _countId:
        return Quantity.count();
      case _gramId:
        return Quantity.gram();
      case _milliliterId:
        return Quantity.milliliter();
      default:
        throw Error();
    }
  }

  static List<Quantity> values() {
    return [Quantity.count(), Quantity.gram(), Quantity.milliliter()];
  }
}

extension QuantityExtention on Quantity {
  String id() {
    return this.when(count: () {
      return _countId;
    }, gram: () {
      return _gramId;
    }, milliliter: () {
      return _milliliterId;
    });
  }

  int unit() {
    return this.when(count: () {
      return _countUnit;
    }, gram: () {
      return _gramUnit;
    }, milliliter: () {
      return _milliliterUnit;
    });
  }

  String suffix(BuildContext context) {
    return this.when(count: () {
      return AppLocalizations.of(context)!.quantityCountSuffix;
    }, gram: () {
      return AppLocalizations.of(context)!.quantityGramSuffix;
    }, milliliter: () {
      return AppLocalizations.of(context)!.quantityMilliliterSuffix;
    });
  }

  String label(BuildContext context) {
    return this.when(count: () {
      return AppLocalizations.of(context)!.quantityCountLabel;
    }, gram: () {
      return AppLocalizations.of(context)!.quantityGramLabel;
    }, milliliter: () {
      return AppLocalizations.of(context)!.quantityMilliliterLabel;
    });
  }
}
