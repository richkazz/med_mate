// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';

/// Represents the state of the landing page.
class LandingPageState extends Equatable {
  const LandingPageState({
    required this.nextDosageTime,
    this.drugs = const [],
    this.landingPageEnum = LandingPageEnum.initial,
  });
  final List<Drug> drugs;
  final LandingPageEnum landingPageEnum;
  final (Duration, Drug, int) nextDosageTime;

  /// Creates a copy of the state with optional new values.
  LandingPageState copyWith({
    List<Drug>? drugs,
    LandingPageEnum? landingPageEnum,
    (Duration, Drug, int)? nextDosageTime,
  }) {
    return LandingPageState(
      drugs: drugs ?? this.drugs,
      landingPageEnum: landingPageEnum ?? this.landingPageEnum,
      nextDosageTime: nextDosageTime ?? this.nextDosageTime,
    );
  }

  @override
  List<Object?> get props =>
      [...drugs, landingPageEnum, drugs.length, nextDosageTime];
}
