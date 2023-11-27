// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';

/// Cubit for handling sign-up-related state management.
class SignUpCubit extends Cubit<SignUpState> {
  final AuthenticationRepository _authenticationRepository;

  /// Constructor for [SignUpCubit].
  ///
  /// [_authenticationRepository] is used for handling
  ///  authentication-related operations.
  SignUpCubit(this._authenticationRepository) : super(SignUpState());

  /// Submits the sign-up form, triggering the registration process.
  Future<void> submit(SignUp signUp) async {
    try {
      // Notify the UI that form submission is in progress.
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.inProgress,
        ),
      );

      // Perform the sign-up operation.
      final result = await _authenticationRepository.signUp(signUp);

      // Handle successful sign-up.
      if (result.isSuccessful) {
        emit(
          state.copyWith(
            submissionStateEnum: FormSubmissionStateEnum.successful,
          ),
        );
        return;
      }

      // Handle sign-up failure.
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.serverFailure,
          errorMessage: result.errorMessage,
        ),
      );
    } catch (e) {
      // Handle unexpected errors during sign-up.
      emit(
        state.copyWith(
          submissionStateEnum: FormSubmissionStateEnum.serverFailure,
          errorMessage: 'Something went wrong',
        ),
      );
    }
  }
}

/// Represents the state of the sign-up form.
class SignUpState {
  final FormSubmissionStateEnum submissionStateEnum;
  final String errorMessage;

  /// Constructor for [SignUpState].
  ///
  /// [submissionStateEnum] represents the current state of form submission.
  /// [errorMessage] contains any error message in case of a failure.
  SignUpState({
    this.submissionStateEnum = FormSubmissionStateEnum.initial,
    this.errorMessage = '',
  });

  /// Creates a new instance of [SignUpState] with updated values.
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
