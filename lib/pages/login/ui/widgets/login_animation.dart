import 'package:flutter/material.dart';
import 'package:zhwaweb/core/theming/app_colors.dart';
import 'package:zhwaweb/core/widgets/circle_loader.dart';

class LoginAnimation extends StatelessWidget {
  final Animation<double> animation;

  const LoginAnimation({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CirclesLoader(animation: animation, animate: true),
                Transform.scale(
                  scale: animation.value,
                  child: Opacity(
                    opacity: animation.value,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/flower.png',
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'مرحبًا بعودتك',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.appGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'سجل دخولك إلى في زهوة',
              style: TextStyle(fontSize: 16, color: AppColors.primary300),
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }
}
