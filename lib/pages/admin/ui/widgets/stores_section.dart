import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/widgets/store_container.dart';
import '../../../../core/widgets/action_icons_row.dart';
import '../../../../core/widgets/search_overlay.dart';
import '../../../../core/widgets/store_selection_overlay.dart';
import '../../../../data/model/store.dart';
import '../../cubit/store_cubit.dart';
import 'add_store_dialog.dart';
import 'edit_store_dialog.dart';

class StoresSection extends StatefulWidget {
  const StoresSection({super.key});

  @override
  State<StoresSection> createState() => _StoresSectionState();
}

class _StoresSectionState extends State<StoresSection> {
  @override
  void initState() {
    super.initState();
    context.read<StoreCubit>().loadStores();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'المتاجر',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.appGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'إدارة جميع المتاجر في النظام',
              style: TextStyle(fontSize: 16, color: AppColors.primary300),
            ),
            const SizedBox(height: 16),
            ActionIconsRow(
              onSearch: () {
                _showSearchDialog();
              },
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddStoreDialog(),
                );
              },
              onEdit: () {
                _showEditDialog();
              },
              onDelete: () {
                _showDeleteDialog();
              },
            ),
            const SizedBox(height: 24),
            BlocBuilder<StoreCubit, StoreState>(
              builder: (context, state) {
                if (state is StoreLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StoreError) {
                  return Center(
                    child: Column(
                      children: [
                        Text('خطأ: ${state.message}'),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<StoreCubit>().loadStores(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                } else if (state is StoreLoaded) {
                  final activeStores = state.stores
                      .where((store) => store.isActive)
                      .toList();

                  if (activeStores.isEmpty) {
                    return const Center(child: Text('لا توجد متاجر متاحة'));
                  }
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: activeStores.map((store) {
                      return StoreContainer(
                        imageUrl: store.image,
                        storeName: store.name,
                        store: store,
                      );
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SearchOverlay(
        title: 'البحث في المتاجر',
        hintText: 'ابحث عن متجر...',
        onSearch: (query) {
          if (query.isEmpty) {
            context.read<StoreCubit>().loadStores(); // Load all stores
          } else {
            context.read<StoreCubit>().loadStores(search: query);
          }
        },
      ),
    );
  }

  void _showEditDialog() {
    final currentState = context.read<StoreCubit>().state;
    if (currentState is StoreLoaded) {
      final activeStores = currentState.stores
          .where((store) => store.isActive)
          .toList();
      if (activeStores.isNotEmpty) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => StoreSelectionOverlay(
            title: 'تعديل متجر',
            stores: activeStores,
            actionText: 'تعديله',
            onStoreSelected: (store) {
              showDialog(
                context: context,
                builder: (context) => EditStoreDialog(store: store),
              );
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا توجد متاجر للتعديل'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا توجد متاجر للتعديل'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showDeleteDialog() {
    final currentState = context.read<StoreCubit>().state;
    if (currentState is StoreLoaded) {
      final activeStores = currentState.stores
          .where((store) => store.isActive)
          .toList();
      if (activeStores.isNotEmpty) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => StoreSelectionOverlay(
            title: 'حذف متجر',
            stores: activeStores,
            actionText: 'حذفه',
            onStoreSelected: (store) {
              _confirmDelete(store);
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا توجد متاجر للحذف'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا توجد متاجر للحذف'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _confirmDelete(Store store) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'تأكيد الحذف',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'هذا الإجراء لا يمكن التراجع عنه',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.appGreen.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.store,
                              color: AppColors.appGreen,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  store.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.appGreen,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${store.sector} - ${store.city}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'هل أنت متأكد من حذف هذا المتجر؟',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey[400]!),
                              ),
                            ),
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<StoreCubit>().deleteStore(store.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم حذف المتجر "${store.name}" بنجاح',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'حذف المتجر',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
