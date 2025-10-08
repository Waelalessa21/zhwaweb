import 'package:flutter/material.dart';
import 'package:zhwaweb/core/helper/extension.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/constants/arabic_strings.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: _buildAppBar(context),
      body: Container(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        ArabicStrings.myStore,
        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: AppColors.appGreen,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () => context.pushReplacementNamed('/login'),
          icon: const Icon(Icons.logout, color: AppColors.white),
        ),
      ],
    );
  }
}
