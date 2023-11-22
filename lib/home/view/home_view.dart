import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/home/home.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';
import 'package:med_mate/landing_page/landing_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((HomeCubit cubit) => cubit.state.tabIndex);
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(
          listenWhen: (previous, current) =>
              previous.showLoginOverlay != current.showLoginOverlay,
          listener: (context, state) {
            if (state.showLoginOverlay) {}
          },
        ),
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: const [LandingPage()],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: selectedTab,
          onTap: (value) => context.read<HomeCubit>().setTab(value),
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });
  final int currentIndex;
  final ValueChanged<int> onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.bottomNavBarColor,
              ),
              child: BottomNavigationBar(
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.transparent,
                selectedLabelStyle: ContentTextStyle.labelSmall,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    activeIcon:
                        Assets.icons.home04Active.svg(package: 'app_ui'),
                    icon: Assets.icons.home04.svg(package: 'app_ui'),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    activeIcon:
                        Assets.icons.pieChartActive.svg(package: 'app_ui'),
                    icon: Assets.icons.pieChart.svg(package: 'app_ui'),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    activeIcon:
                        Assets.icons.setting03Active.svg(package: 'app_ui'),
                    icon: Assets.icons.setting03.svg(package: 'app_ui'),
                    label: 'Home',
                  ),
                ],
                currentIndex: currentIndex,
                onTap: onTap,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: AppSpacing.lg,
        ),
      ],
    );
  }
}
