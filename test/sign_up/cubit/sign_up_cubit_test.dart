import 'package:bloc_test/bloc_test.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_mate/application/application.dart';
import 'package:med_mate/signup/cubit/sign_up_cubit.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('SignUpCubit', () {
    late AuthenticationRepository authenticationRepository;
    late SignUpCubit signUpCubit;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      signUpCubit = SignUpCubit(authenticationRepository);
    });

    group('submit', () {
      const validSignUp = SignUp(
        email: 'test@example.com',
        password: 'password',
        firstname: 'karo',
        lastname: 'richard',
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [inProgress, successful] states for valid sign-up',
        build: () {
          when(() => authenticationRepository.signUp(validSignUp)).thenAnswer(
            (_) async => Result<bool>(
              isSuccessful: true,
              data: true,
              errorMessage: null,
            ),
          );
          return signUpCubit;
        },
        act: (cubit) async {
          await cubit.submit(validSignUp);
        },
        expect: () => [
          SignUpState(submissionStateEnum: FormSubmissionStateEnum.inProgress),
          SignUpState(submissionStateEnum: FormSubmissionStateEnum.successful),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [inProgress, serverFailure] states for unsuccessful sign-up',
        build: () {
          when(() => authenticationRepository.signUp(validSignUp)).thenAnswer(
            (_) async => Result<bool>(
              isSuccessful: false,
              errorMessage: 'Username already exists',
            ),
          );
          return signUpCubit;
        },
        act: (cubit) async {
          await cubit.submit(validSignUp);
        },
        expect: () => [
          SignUpState(submissionStateEnum: FormSubmissionStateEnum.inProgress),
          SignUpState(
            submissionStateEnum: FormSubmissionStateEnum.serverFailure,
            errorMessage: 'Username already exists',
          ),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [inProgress, serverFailure] states for unexpected error',
        build: () {
          when(() => authenticationRepository.signUp(validSignUp))
              .thenThrow(Exception('Test exception'));
          return signUpCubit;
        },
        act: (cubit) async {
          await cubit.submit(validSignUp);
        },
        expect: () => [
          SignUpState(submissionStateEnum: FormSubmissionStateEnum.inProgress),
          SignUpState(
            submissionStateEnum: FormSubmissionStateEnum.serverFailure,
            errorMessage: 'Something went wrong',
          ),
        ],
      );
    });
  });
}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}
