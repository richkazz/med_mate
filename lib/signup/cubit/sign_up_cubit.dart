// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthenticationRepository _authenticationRepository;
  SignUpCubit(this._authenticationRepository) : super(SignUpState());
  Future<void> submit(SignUp signUp) async {
    try {
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.inProgress,
        ),
      );

      final result = await _authenticationRepository.signUp(signUp);
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
    } catch (e) {
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.serverFailure,
          errorMessage: 'Something went wrong',
        ),
      );
    }
  }
}

class SignUpState {
  final FormSubmissionStateEnum submissionStateEnum;
  final String errorMessage;
  SignUpState({
    this.submissionStateEnum = FormSubmissionStateEnum.initial,
    this.errorMessage = '',
  });

  SignUpState copyWith({
    FormSubmissionStateEnum? submissionStateEnum,
    String? errorMessage,
  }) {
    return SignUpState(
      submissionStateEnum: submissionStateEnum ?? this.submissionStateEnum,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
