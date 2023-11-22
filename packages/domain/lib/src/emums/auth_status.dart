/// Enum to represent the authentication status of a user.
enum AuthStatus {
  /// Authentication successful.
  successful,

  /// Login successful.
  loginSuccessful,

  /// Wrong password provided.
  wrongPassword,

  /// Email address already exists.
  emailAlreadyExists,

  /// Invalid email address.
  invalidEmail,

  /// Weak password provided.
  weakPassword,

  /// Unknown error occurred during authentication.
  unknown,

  /// Email verification failed.
  emailVerifiedError,

  /// User not found.
  userNotFound,

  /// Recent login required.
  requiresRecentLogin,

  /// Name change required.
  nameChange,

  /// Invalid login attempt.
  invalidLoginAttempt,

  /// Network error.
  networkError,
}

class AuthExceptionHandler {
  static AuthStatus errorCodeToAuthStatusEnum(String code) {
    switch (code) {
      case 'network-request-failed':
        return AuthStatus.networkError;

      case 'invalid-email':
        return AuthStatus.invalidEmail;

      case 'wrong-password':
        return AuthStatus.wrongPassword;

      case 'requires-recent-login':
        return AuthStatus.requiresRecentLogin;

      case 'weak-password':
        return AuthStatus.weakPassword;

      case 'email-already-in-use':
        return AuthStatus.emailAlreadyExists;

      case 'user-not-found':
        return AuthStatus.userNotFound;

      default:
        return AuthStatus.unknown;
    }
  }

  static String generateErrorMessage(AuthStatus error) {
    switch (error) {
      case AuthStatus.invalidEmail:
        return 'Your email address appears to be malformed.';
      case AuthStatus.successful:
        return 'Your account has been created, check your mail'
            ' for a verification link.';
      case AuthStatus.loginSuccessful:
        return 'Login successful';

      case AuthStatus.nameChange:
        return 'successful';

      case AuthStatus.requiresRecentLogin:
        return 'This operation is sensitive and requires recent authentication.'
            ' Log in again before retrying this request.';

      case AuthStatus.weakPassword:
        return 'Your password should be at least 6 characters.';

      case AuthStatus.wrongPassword:
        return 'Your email or password is wrong.';

      case AuthStatus.emailAlreadyExists:
        return 'The email address is already in use by another account.';

      case AuthStatus.emailVerifiedError:
        return 'An email has been sent, please go verify.';

      case AuthStatus.userNotFound:
        return 'Invalid email or password';

      case AuthStatus.networkError:
        return 'A network error has occurred.'
            '\nCheck your connection and try again.';
      case AuthStatus.unknown:
        return 'Something went wrong';
      case AuthStatus.invalidLoginAttempt:
        return 'your email or password is incorrect';
    }
  }
}
