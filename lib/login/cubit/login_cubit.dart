// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;
  LoginCubit(this._authenticationRepository) : super(LoginState());
  Future<void> submit(Login login) async {
    emit(
      state.copyWith(
        submissionStateEnum: FormSubmissionStateEnum.inProgress,
      ),
    );
    final result = await _authenticationRepository.signIn(login);
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

class LoginState {
  final FormSubmissionStateEnum submissionStateEnum;
  final String errorMessage;
  LoginState({
    this.submissionStateEnum = FormSubmissionStateEnum.initial,
    this.errorMessage = '',
  });

  LoginState copyWith({
    FormSubmissionStateEnum? submissionStateEnum,
    String? errorMessage,
  }) {
    return LoginState(
      submissionStateEnum: submissionStateEnum ?? this.submissionStateEnum,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
