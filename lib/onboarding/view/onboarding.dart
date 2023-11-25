import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:med_mate/signup/sign_up.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/widgets/widget.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: OnboardingPage());

  @override
  Widget build(BuildContext context) {
    return const OnboardingView();
  }
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF9F9FF),
              Color(0xFF6777F9),
              Color(0xFF4C5FF7),
            ],
            stops: [0.0, 0.5285, 1.0817],
            transform: GradientRotation(178.97),
          ),
        ),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height + 20,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const SizedBox(
                      height: AppSpacing.xxxlg,
                    ),
                    Text(
                      l10n.medMate,
                      style: theme.textTheme.headlineMedium!
                          .copyWith(color: AppColors.white),
                    ),
                    const SizedBox(
                      height: AppSpacing.xlg,
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 250),
                      child: Text(
                        l10n.oneStepToAdherence,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall!.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.xlg,
                    ),
                    OnboardingButtonWrapper(
                      child: AppButton.primary(
                        borderRadius: 25,
                        color: const Color.fromRGBO(51, 66, 242, 1),
                        onPressed: () {
                          Navigator.of(context).push(
                            SlidePageRoute<SignUpPage>(
                              page: const SignUpPage(
                                key: ValueKey<String>('SignUpPage'),
                              ),
                            ),
                          );
                        },
                        child: AppButtonText(
                          text: l10n.signUp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.lg,
                    ),
                    OnboardingButtonWrapper(
                      child: AppButton.smallOutlineWithWhiteBorderTransparent(
                        onPressed: () {},
                        child: AppButtonText(
                          text: l10n.logIn,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.xlg,
                    ),
                    const Spacer(),
                    Assets.images.fpd.image(
                      package: 'app_ui',
                      fit: BoxFit.fill,
                      width: MediaQuery.sizeOf(context).width,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingButtonWrapper extends StatelessWidget {
  const OnboardingButtonWrapper({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 34,
      child: child,
    );
  }
}

class GradientEllipsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width,
      height: size.height,
    );

    final paint = Paint()
      ..strokeWidth = 0
      ..blendMode = BlendMode.lighten
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF6777F9).withOpacity(0.8),
          const Color(0xFF4C5FF7).withOpacity(0.2),
        ],
        stops: const [0.0, 0.5285, 1.0817],
      ).createShader(rect);

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
