import 'package:bloc_test/bloc_test.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_mate/application/application.dart';
import 'package:med_mate/login/cubit/login_cubit.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('LoginCubit', () {
    late AuthenticationRepository authenticationRepository;
    late LoginCubit loginCubit;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      loginCubit = LoginCubit(authenticationRepository);
    });

    group('submit', () {
      const validLogin = Login(email: 'test@example.com', password: 'password');

      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, successful] states for valid login',
        build: () {
          when(() => authenticationRepository.signIn(validLogin)).thenAnswer(
            (_) async => Result<User>(
              isSuccessful: true,
              data: User.anonymous,
              errorMessage: null,
            ),
          );
          return loginCubit;
        },
        act: (cubit) async {
          await cubit.submit(validLogin);
        },
        expect: () => [
          LoginState(submissionStateEnum: FormSubmissionStateEnum.inProgress),
          LoginState(submissionStateEnum: FormSubmissionStateEnum.successful),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, serverFailure] states for unsuccessful login',
        build: () {
          when(() => authenticationRepository.signIn(validLogin)).thenAnswer(
            (_) async => Result<User>(
              isSuccessful: true,
              data: User.anonymous,
              errorMessage: 'Invalid credentials',
            ),
          );
          return loginCubit;
        },
        act: (cubit) async {
          await cubit.submit(validLogin);
        },
        expect: () => [
          LoginState(submissionStateEnum: FormSubmissionStateEnum.inProgress),
          LoginState(
            submissionStateEnum: FormSubmissionStateEnum.serverFailure,
            errorMessage: 'Invalid credentials',
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, serverFailure] states for unexpected error',
        build: () {
          when(() => authenticationRepository.signIn(validLogin))
              .thenThrow(Exception('Test exception'));
          return loginCubit;
        },
        act: (cubit) async {
          await cubit.submit(validLogin);
        },
        expect: () => [
          LoginState(submissionStateEnum: FormSubmissionStateEnum.inProgress),
          LoginState(
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


