import 'package:flutter/widgets.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/home/home.dart';
import 'package:med_mate/onboarding/onboarding.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.onboardingRequired:
      return [OnboardingPage.page()];
    case AppStatus.unauthenticated:
      return [OnboardingPage.page()];
    case AppStatus.authenticated:
      return [HomePage.page()];
  }
}
