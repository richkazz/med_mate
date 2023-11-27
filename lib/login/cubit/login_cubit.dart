// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';

/// Cubit for handling login-related state management.
class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  /// Constructor for [LoginCubit].
  ///
  /// [_authenticationRepository] is used for handling
  /// authentication-related operations.
  LoginCubit(this._authenticationRepository) : super(LoginState());

  /// Submits the login form, triggering the authentication process.
  Future<void> submit(Login login) async {
    try {
      // Notify the UI that form submission is in progress.
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.inProgress,
        ),
      );

      // Perform the login operation.
      final result = await _authenticationRepository.signIn(login);

      // Handle successful login.
      if (result.isSuccessful) {
        emit(
          state.copyWith(
            submissionStateEnum: FormSubmissionStateEnum.successful,
          ),
        );
        return;
      }

      // Handle login failure.
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.serverFailure,
          errorMessage: result.errorMessage,
        ),
      );
    } catch (e) {
      // Handle unexpected errors during login.
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.serverFailure,
          errorMessage: 'Something went wrong',
        ),
      );
    }
  }
}

/// Represents the state of the login form.
class LoginState {
  final FormSubmissionStateEnum submissionStateEnum;
  final String errorMessage;

  /// Constructor for [LoginState].
  ///
  /// [submissionStateEnum] represents the current state of form submission.
  /// [errorMessage] contains any error message in case of a failure.
  LoginState({
    this.submissionStateEnum = FormSubmissionStateEnum.initial,
    this.errorMessage = '',
  });

  /// Creates a new instance of [LoginState] with updated values.
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
