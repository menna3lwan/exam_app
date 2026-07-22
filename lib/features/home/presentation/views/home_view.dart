import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubits/explore/explore_cubit.dart';
import '../cubits/results/results_cubit.dart';
import 'tabs/explore/explore_tab.dart';
import 'tabs/profile/profile_tab.dart';
import 'tabs/result/result_tab.dart';

/// Bottom navigation shell — the main container after login.
///
/// Provides [ExploreCubit] to the widget tree and loads subjects on init.
/// Uses [IndexedStack] so tab state is preserved when switching.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ExploreCubit>()..loadSubjects(),
        ),
        BlocProvider(
          create: (_) => getIt<ResultsCubit>()..loadHistory(),
        ),
      ],
      child: const _HomeShell(),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _currentIndex = 0;

  static const _tabs = [
    ExploreTab(),
    ResultTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.black.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: AppAssets.iconHome,
                label: 'Explore',
                isActive: _currentIndex == 0,
                onTap: () => _switchTab(0),
              ),
              _NavItem(
                icon: AppAssets.iconResultDraft,
                label: 'Result',
                isActive: _currentIndex == 1,
                onTap: () => _switchTab(1),
              ),
              _NavItem(
                icon: AppAssets.iconPerson,
                label: 'Profile',
                isActive: _currentIndex == 2,
                onTap: () => _switchTab(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _switchTab(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.gray;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active tab has light blue pill background behind icon (Figma)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              decoration: isActive
                  ? BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(16),
                    )
                  : null,
              child: SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
