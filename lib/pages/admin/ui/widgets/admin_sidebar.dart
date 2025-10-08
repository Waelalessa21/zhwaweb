import 'package:flutter/material.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/constants/arabic_strings.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedOption;
  final Function(int) onOptionSelected;

  const AdminSidebar({
    super.key,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> options = [
      ArabicStrings.controlPanel,
      ArabicStrings.stores,
      ArabicStrings.offers,
      ArabicStrings.requests,
    ];

    return Container(
      width: 200,
      color: AppColors.appGreen.withOpacity(0.1),
      child: Column(
        children: [
          const SizedBox(height: 20),
          ...List.generate(options.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: InkWell(
                onTap: () => onOptionSelected(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: selectedOption == index
                        ? AppColors.appGreen
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          options[index],
                          style: TextStyle(
                            color: selectedOption == index
                                ? AppColors.white
                                : AppColors.appGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _getIconForOption(index),
                        color: selectedOption == index
                            ? AppColors.white
                            : AppColors.appGreen,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _getIconForOption(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard;
      case 1:
        return Icons.store;
      case 2:
        return Icons.local_offer;
      case 3:
        return Icons.pending_actions;
      default:
        return Icons.dashboard;
    }
  }
}
