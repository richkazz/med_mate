/// Enum representing the various states of a form submission.
enum FormSubmissionStateEnum {
  /// Initial state before any submission
  initial,

  /// Submission is in progress
  inProgress,

  /// Submission failed due to a network issue
  networkFailure,

  /// Submission failed due to a server issue
  serverFailure,

  /// Submission was successful
  successful,

  /// Submission encountered an error
  error,

  /// Submission failed due to authentication issues
  authenticationError
}

/// Extension on FormSubmissionStateEnum providing utility methods.
extension FormSubmissionStateEnumExtension on FormSubmissionStateEnum {
  /// Checks if the form is in the initial state.
  bool get isInitial => this == FormSubmissionStateEnum.initial;

  /// Checks if the form submission is in progress.
  bool get isInProgress => this == FormSubmissionStateEnum.inProgress;

  /// Checks if the form submission failed due to a network issue.
  bool get isNetworkFailure => this == FormSubmissionStateEnum.networkFailure;

  /// Checks if the form submission failed due to a server issue.
  bool get isServerFailure => this == FormSubmissionStateEnum.serverFailure;

  /// Checks if the form submission was successful.
  bool get isSuccessful => this == FormSubmissionStateEnum.successful;

  /// Checks if the form submission encountered an error.
  bool get isError => this == FormSubmissionStateEnum.error;

  /// Checks if the form submission failed due to authentication issues.
  bool get isAuthenticationError =>
      this == FormSubmissionStateEnum.authenticationError;
}
