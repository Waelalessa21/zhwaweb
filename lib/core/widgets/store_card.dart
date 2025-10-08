import 'package:flutter/material.dart';
import '../theming/app_colors.dart';
import '../constants/arabic_strings.dart';
import '../../data/model/store.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const StoreCard({
    super.key,
    required this.store,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showActions) ...[
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, color: AppColors.appPurple),
                  ),
                ],
                Expanded(
                  child: Text(
                    store.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appGreen,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              store.description,
              style: const TextStyle(fontSize: 14, color: AppColors.primary300),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    store.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.appGreen,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.appPurple,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  store.phone,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.appGreen,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(width: 4),
                const Icon(Icons.phone, size: 16, color: AppColors.appPurple),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    store.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.appGreen,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.email, size: 16, color: AppColors.appPurple),
              ],
            ),
            if (store.products.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '${ArabicStrings.products}: ${store.products.join(', ')}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary300,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
