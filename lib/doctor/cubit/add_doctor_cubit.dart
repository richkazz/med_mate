// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';

class AddDoctorCubit extends Cubit<AddDoctorState> {
  final DoctorRepository _doctorRepository;
  AddDoctorCubit(this._doctorRepository) : super(AddDoctorState());
  Future<void> submit(String email) async {
    emit(
      state.copyWith(
        submissionStateEnum: FormSubmissionStateEnum.inProgress,
      ),
    );
    final result = await _doctorRepository.linkADoctor(email);
    if (result.isSuccessful) {
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.successful,
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

class AddDoctorState {
  final FormSubmissionStateEnum submissionStateEnum;
  final String errorMessage;
  AddDoctorState({
    this.submissionStateEnum = FormSubmissionStateEnum.initial,
    this.errorMessage = '',
  });

  AddDoctorState copyWith({
    FormSubmissionStateEnum? submissionStateEnum,
    String? errorMessage,
  }) {
    return AddDoctorState(
      submissionStateEnum: submissionStateEnum ?? this.submissionStateEnum,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
