import 'package:domain/domain.dart';

class DrugRepository {
  DrugRepository({required ResultService resultService})
      : _resultService = resultService;

  final ResultService _resultService;
  Future<Result<Drug>> createDrug(Drug drug) async {
    globalTestDrugList.add(drug);
    return _resultService.successful<Drug>(drug);
  }

  Future<Result<Drug>> updateDrug(Drug drug, int drugId) async {
    final indexOfDrug = globalTestDrugList.indexWhere((element) {
      return element.isEqual(drug);
    });
    if (indexOfDrug == -1) {
      return _resultService
          .error<Drug>('Could not find drug with the particular id');
    }
    globalTestDrugList[indexOfDrug] = drug;
    return _resultService.successful<Drug>(drug);
  }

  Future<Result<List<Drug>>> getDrugs() async {
    return _resultService.successful<List<Drug>>(globalTestDrugList);
  }
}
