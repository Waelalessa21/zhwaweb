import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../data/model/subscription.dart';
import '../../cubit/subscription_cubit.dart';
import 'subscription_approval_dialog.dart';

class RequestsSection extends StatefulWidget {
  const RequestsSection({super.key});

  @override
  State<RequestsSection> createState() => _RequestsSectionState();
}

class _RequestsSectionState extends State<RequestsSection> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionCubit>().loadSubscriptions(status: 'pending');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'طلبات الاشتراك',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.appGreen,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'مراجعة وموافقة على طلبات الاشتراك الجديدة',
            style: TextStyle(fontSize: 16, color: AppColors.primary300),
          ),
          const SizedBox(height: 24),
          BlocBuilder<SubscriptionCubit, SubscriptionState>(
            builder: (context, state) {
              if (state is SubscriptionLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SubscriptionError) {
                return Center(
                  child: Column(
                    children: [
                      Text('خطأ: ${state.message}'),
                      ElevatedButton(
                        onPressed: () => context
                            .read<SubscriptionCubit>()
                            .loadSubscriptions(status: 'pending'),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              } else if (state is SubscriptionLoaded) {
                if (state.subscriptions.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد طلبات اشتراك في الانتظار',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary300,
                      ),
                    ),
                  );
                }

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: state.subscriptions.map((subscription) {
                    return _buildRequestCard(subscription);
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

  Widget _buildRequestCard(Subscription subscription) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child:
                  subscription.image != null && subscription.image!.isNotEmpty
                  ? Image.network(subscription.image!, fit: BoxFit.cover)
                  : const Icon(Icons.store, size: 50, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  subscription.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appGreen,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
                Text(
                  '${subscription.sector} - ${subscription.city}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
                Text(
                  subscription.description != null &&
                          subscription.description!.isNotEmpty
                      ? subscription.description!
                      : 'لا يوجد وصف',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showRequestDetails(subscription),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.appGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'عرض التفاصيل',
                          style: TextStyle(color: AppColors.appGreen),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _approveRequest(subscription),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.appGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'موافقة',
                          style: TextStyle(color: Colors.white),
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
    );
  }

  void _showRequestDetails(Subscription subscription) {
    showDialog(
      context: context,
      builder: (context) =>
          SubscriptionApprovalDialog(subscription: subscription),
    );
  }

  void _approveRequest(Subscription subscription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'تأكيد الموافقة',
          style: TextStyle(color: AppColors.appGreen),
          textDirection: TextDirection.rtl,
        ),
        content: Text(
          'هل أنت متأكد من الموافقة على طلب الاشتراك لـ "${subscription.name}"؟',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SubscriptionCubit>().approveSubscription(
                subscription.id,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم الموافقة على طلب الاشتراك لـ "${subscription.name}"',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.appGreen,
            ),
            child: const Text('موافقة'),
          ),
        ],
      ),
    );
  }
}
