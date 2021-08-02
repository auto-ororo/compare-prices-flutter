import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quantity_type.freezed.dart';

const _countId = "1";
const _gramId = "2";
const _milliliterId = "3";

const _countUnit = 1;
const _gramUnit = 100;
const _milliliterUnit = 100;

@freezed
class QuantityType<T> with _$QuantityType<T> {
  const factory QuantityType.count() = _count;
  const factory QuantityType.gram() = _gram;
  const factory QuantityType.milliliter() = _milliliter;

  static QuantityType getTypeById(String id) {
    switch (id) {
      case _countId:
        return QuantityType.count();
      case _gramId:
        return QuantityType.gram();
      case _milliliterId:
        return QuantityType.milliliter();
      default:
        throw Error();
    }
  }

  static List<QuantityType> values() {
    return [
      QuantityType.count(),
      QuantityType.gram(),
      QuantityType.milliliter()
    ];
  }
}

extension QuantityExtention on QuantityType {
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

  bool isEqualToUnit(int quantity) {
    return this.when(count: () {
      return quantity == _countUnit;
    }, gram: () {
      return quantity == _gramUnit;
    }, milliliter: () {
      return quantity == _milliliterUnit;
    });
  }
}
