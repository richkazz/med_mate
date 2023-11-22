import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum LandingPageEnum {
  initial,
  calenderSelect;

  bool get isCalenderSelect => this == LandingPageEnum.calenderSelect;
}

class LandingPageCubit extends Cubit<LandingPageState> {
  LandingPageCubit() : super(const LandingPageState());

  void saveNewDrugAdded(Drug drug) {
    final newListOfDrugs = [...state.drugs, drug];
    emit(state.copyWith(drugs: newListOfDrugs));
  }

  void showCalenderToSelect() {
    emit(state.copyWith(landingPageEnum: LandingPageEnum.calenderSelect));
    emit(state.copyWith(landingPageEnum: LandingPageEnum.initial));
  }
}

class LandingPageState extends Equatable {
  const LandingPageState({
    this.drugs = const [],
    this.landingPageEnum = LandingPageEnum.initial,
  });
  final List<Drug> drugs;
  final LandingPageEnum landingPageEnum;
  LandingPageState copyWith({
    List<Drug>? drugs,
    LandingPageEnum? landingPageEnum,
  }) {
    return LandingPageState(
      drugs: drugs ?? this.drugs,
      landingPageEnum: landingPageEnum ?? this.landingPageEnum,
    );
  }

  List<Drug> get sortedDrugs {
    final newDrug = <Drug>[];
    for (final element in drugs) {
      for (final drg in element.doseTimeAndCount) {
        newDrug.add(element.copyWith(doseTimeAndCount: [drg]));
      }
    }
    // ignore: cascade_invocations
    newDrug.sort(compareDrugs);
    return newDrug;
  }

  @override
  List<Object?> get props => [...drugs, landingPageEnum];
}
