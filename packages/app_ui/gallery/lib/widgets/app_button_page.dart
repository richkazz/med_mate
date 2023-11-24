import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppButtonPage extends StatelessWidget {
  const AppButtonPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AppButtonPage());
  }

  @override
  Widget build(BuildContext context) {
    const contentSpacing = AppSpacing.lg;
    final appButtonList = [
      _AppButtonItem(
        buttonType: ButtonType.google,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.google.svg(),
            const SizedBox(width: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xxs),
              child: Assets.images.continueWithGoogle.svg(),
            ),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.apple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.apple.svg(),
            const SizedBox(width: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Assets.images.continueWithApple.svg(),
            ),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.facebook,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.facebook.svg(),
            const SizedBox(width: AppSpacing.lg),
            Assets.images.continueWithFacebook.svg(),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.twitter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.twitter.svg(),
            const SizedBox(width: AppSpacing.lg),
            Assets.images.continueWithTwitter.svg(),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.email,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.emailOutline.svg(),
            const SizedBox(width: AppSpacing.lg),
            const Text('Continue with Email'),
          ],
        ),
      ),
      const _AppButtonItem(
        buttonType: ButtonType.login,
        child: Text('Log in'),
      ),
      const _AppButtonItem(
        buttonType: ButtonType.subscribe,
        child: Text('Subscribe'),
      ),
      const _AppButtonItem(
        buttonType: ButtonType.information,
        child: Text('Next'),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + contentSpacing,
        ),
        child: _AppButtonItem(
          buttonType: ButtonType.trial,
          child: Text('Start free trial'),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + contentSpacing,
        ),
        child: _AppButtonItem(
          buttonType: ButtonType.logout,
          child: Text('Logout'),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + contentSpacing,
        ),
        child: _AppButtonItem(
          buttonType: ButtonType.details,
          child: Text('View details'),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + contentSpacing,
        ),
        child: _AppButtonItem(
          buttonType: ButtonType.cancel,
          child: Text('Cancel anytime'),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + contentSpacing,
        ),
        child: _AppButtonItem(
          buttonType: ButtonType.watchVideo,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_call_sharp),
              SizedBox(width: AppSpacing.sm),
              Text('Watch a video to view this article'),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + contentSpacing,
        ),
        child: Container(
          height: 100,
          color: AppColors.darkAqua,
          child: const _AppButtonItem(
            buttonType: ButtonType.watchVideoDark,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_call_sharp),
                SizedBox(width: AppSpacing.sm),
                Text('Watch a video to view this article'),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      Container(
        height: 100,
        color: AppColors.darkBackground,
        child: const _AppButtonItem(
          buttonType: ButtonType.logInSubscribe,
          child: Text('Log In'),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('App Buttons')),
      body: ListView(children: appButtonList),
    );
  }
}

enum ButtonType {
  google,
  apple,
  facebook,
  twitter,
  email,
  login,
  subscribe,
  information,
  trial,
  logout,
  details,
  cancel,
  watchVideo,
  watchVideoDark,
  logInSubscribe
}

class _AppButtonItem extends StatelessWidget {
  const _AppButtonItem({required this.buttonType, required this.child});

  final Widget child;
  final ButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: SizedBox(),
    );
  }
}
