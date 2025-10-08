import 'package:flutter/material.dart';
import 'package:zhwaweb/core/helper/extension.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/constants/arabic_strings.dart';

class AdminHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onAddPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onLogoutPressed;

  const AdminHeader({
    super.key,
    this.onAddPressed,
    this.onEditPressed,
    this.onDeletePressed,
    this.onLogoutPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appGreen,
      elevation: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: 0,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Spacer(),
              Center(
                child: Text(
                  ArabicStrings.adminDashboard,
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: IconButton(
                  onPressed:
                      onLogoutPressed ??
                      () => context.pushReplacementNamed('/login'),
                  icon: const Icon(Icons.logout, color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
