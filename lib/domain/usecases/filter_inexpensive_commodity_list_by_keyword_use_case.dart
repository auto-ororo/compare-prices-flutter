import 'package:compare_prices/domain/entities/commodity_row.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';

class FilterInexpensiveCommodityListByKeywordUseCase extends UseCase<
    List<CommodityRow>, FilterInexpensiveCommodityListByKeywordUseCaseParams> {
  FilterInexpensiveCommodityListByKeywordUseCase();

  @override
  Result<List<CommodityRow>> call(
      FilterInexpensiveCommodityListByKeywordUseCaseParams params) {
    return Result.guard(() {
      if (params.searchWord == "") {
        return params.list;
      }

      return params.list
          .where((element) => (element.commodity.name
                  .contains(params.searchWord) ||
              (element.mostInexpensiveShop.name.contains(params.searchWord))))
          .toList();
    });
  }
}

class FilterInexpensiveCommodityListByKeywordUseCaseParams {
  final List<CommodityRow> list;
  final String searchWord;

  FilterInexpensiveCommodityListByKeywordUseCaseParams(
      {required this.list, required this.searchWord});
}
