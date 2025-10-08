import 'package:flutter/material.dart';
import '../theming/app_colors.dart';

class ActionIconsRow extends StatelessWidget {
  final VoidCallback? onSearch;
  final VoidCallback? onAdd;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ActionIconsRow({
    super.key,
    this.onSearch,
    this.onAdd,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.appGreen, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionIcon(icon: Icons.search, onTap: onSearch),
          const SizedBox(width: 16),
          _buildActionIcon(icon: Icons.add, onTap: onAdd),
          const SizedBox(width: 16),
          _buildActionIcon(icon: Icons.edit, onTap: onEdit),
          const SizedBox(width: 16),
          _buildActionIcon(icon: Icons.delete, onTap: onDelete),
        ],
      ),
    );
  }

  Widget _buildActionIcon({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: AppColors.appGreen, size: 20),
      ),
    );
  }
}
