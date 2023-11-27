// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';

/// Represents the state of the landing page.
class LandingPageState extends Equatable {
  const LandingPageState({
    required this.nextDosageTime,
    this.errorMessage = '',
    this.landingPageEnum = LandingPageEnum.initial,
    this.submissionStateEnum = FormSubmissionStateEnum.inProgress,
  });
  final LandingPageEnum landingPageEnum;
  final FormSubmissionStateEnum submissionStateEnum;
  final String errorMessage;
  final (Duration, Drug, int) nextDosageTime;

  /// Creates a copy of the state with optional new values.
  LandingPageState copyWith({
    String? errorMessage,
    FormSubmissionStateEnum? submissionStateEnum,
    LandingPageEnum? landingPageEnum,
    (Duration, Drug, int)? nextDosageTime,
  }) {
    return LandingPageState(
      errorMessage: errorMessage ?? this.errorMessage,
      submissionStateEnum: submissionStateEnum ?? this.submissionStateEnum,
      landingPageEnum: landingPageEnum ?? this.landingPageEnum,
      nextDosageTime: nextDosageTime ?? this.nextDosageTime,
    );
  }

  @override
  List<Object?> get props =>
      [landingPageEnum, nextDosageTime, submissionStateEnum];
}
