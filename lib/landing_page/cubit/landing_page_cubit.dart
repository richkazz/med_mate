import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPageCubit extends Cubit<LandingPageState> {
  LandingPageCubit() : super(const LandingPageState());

  void saveNewDrugAdded(Drug drug) {
    final newListOfDrugs = [...state.drugs, drug];
    emit(state.copyWith(drugs: newListOfDrugs));
  }
}

class LandingPageState extends Equatable {
  const LandingPageState({
    this.drugs = const [],
  });
  final List<Drug> drugs;

  LandingPageState copyWith({
    List<Drug>? drugs,
  }) {
    return LandingPageState(
      drugs: drugs ?? this.drugs,
    );
  }

  @override
  List<Object?> get props => [...drugs];
}
