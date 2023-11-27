// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';

class SaveDrugCubit extends Cubit<SaveDrugState> {
  final DrugRepository _drugRepository;
  SaveDrugCubit(this._drugRepository) : super(SaveDrugState(drug: Drug.empty));
  Future<void> saveNewDrugAdded(Drug drug, int userId) async {
    emit(
      state.copyWith(
        submissionStateEnum: FormSubmissionStateEnum.inProgress,
      ),
    );
    final result = await _drugRepository.createDrug(drug, userId);
    if (result.isSuccessful) {
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.successful,
          drug: result.data,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        submissionStateEnum: FormSubmissionStateEnum.serverFailure,
        errorMessage: result.errorMessage,
      ),
    );
  }
}

class SaveDrugState {
  final FormSubmissionStateEnum submissionStateEnum;
  final String errorMessage;
  final Drug drug;
  SaveDrugState({
    required this.drug,
    this.submissionStateEnum = FormSubmissionStateEnum.initial,
    this.errorMessage = '',
  });

  SaveDrugState copyWith({
    FormSubmissionStateEnum? submissionStateEnum,
    String? errorMessage,
    Drug? drug,
  }) {
    return SaveDrugState(
      submissionStateEnum: submissionStateEnum ?? this.submissionStateEnum,
      errorMessage: errorMessage ?? this.errorMessage,
      drug: drug ?? this.drug,
    );
  }
}
