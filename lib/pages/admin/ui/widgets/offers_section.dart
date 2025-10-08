import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/widgets/action_icons_row.dart';
import '../../../../core/widgets/offer_card.dart';
import '../../cubit/offer_cubit.dart';
import 'add_offer_dialog.dart';
import 'edit_offer_dialog.dart';

class OffersSection extends StatefulWidget {
  const OffersSection({super.key});

  @override
  State<OffersSection> createState() => _OffersSectionState();
}

class _OffersSectionState extends State<OffersSection> {
  @override
  void initState() {
    super.initState();
    context.read<OfferCubit>().loadOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'العروض',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.appGreen,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'إدارة جميع العروض والخصومات في النظام',
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
                builder: (context) => const AddOfferDialog(),
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
          BlocBuilder<OfferCubit, OfferState>(
            builder: (context, state) {
              if (state is OfferLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OfferError) {
                return Center(
                  child: Column(
                    children: [
                      Text('خطأ: ${state.message}'),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<OfferCubit>().loadOffers(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              } else if (state is OfferLoaded) {
                if (state.offers.isEmpty) {
                  return const Center(child: Text('لا توجد عروض متاحة'));
                }
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: state.offers.map((offer) {
                    return OfferCard(
                      imageUrl: offer.image,
                      offerTitle: offer.title,
                      offerDescription: offer.description,
                      discountPercentage: offer.discountPercentage.toString(),
                      validUntil: offer.validUntil.toString().split(' ')[0],
                    );
                  }).toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('البحث في العروض'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'ابحث عن عرض...'),
          onSubmitted: (query) {
            Navigator.pop(context);
            context.read<OfferCubit>().loadOffers(search: query);
          },
        ),
      ),
    );
  }

  void _showEditDialog() {
    final state = context.read<OfferCubit>().state;
    if (state is OfferLoaded && state.offers.isNotEmpty) {
      final offer = state.offers.first;
      showDialog(
        context: context,
        builder: (context) => EditOfferDialog(
          offer: {
            'id': offer.id,
            'title': offer.title,
            'description': offer.description,
            'discount': offer.discountPercentage,
            'image': offer.image,
            'validUntil': offer.validUntil.toIso8601String(),
            'storeId': offer.storeId,
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('لا توجد عروض للتعديل')));
    }
  }

  void _showDeleteDialog() {
    final state = context.read<OfferCubit>().state;
    if (state is OfferLoaded && state.offers.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('حذف عرض'),
          content: const Text('هل أنت متأكد من حذف هذا العرض؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<OfferCubit>().deleteOffer(state.offers.first.id);
              },
              child: const Text('حذف'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('لا توجد عروض للحذف')));
    }
  }
}
