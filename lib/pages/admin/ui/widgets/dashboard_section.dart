import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zhwaweb/core/widgets/info_card.dart';
import '../../../../core/theming/app_colors.dart';
import '../../cubit/store_cubit.dart';
import '../../cubit/offer_cubit.dart';

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'لوحة التحكم',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.appGreen,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'مرحبًا بك في لوحة تحكم المدير، يمكنك إدارة المتاجر والعروض من هنا',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primary300,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: BlocBuilder<StoreCubit, StoreState>(
                  builder: (context, state) {
                    int storeCount = 0;
                    if (state is StoreLoaded) {
                      storeCount = state.stores.length;
                    }
                    return InfoCard(
                      title: 'عدد المتاجر',
                      value: storeCount.toString(),
                      icon: Icons.store,
                      iconColor: AppColors.appGreen,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BlocBuilder<OfferCubit, OfferState>(
                  builder: (context, state) {
                    int offerCount = 0;
                    if (state is OfferLoaded) {
                      offerCount = state.offers.length;
                    }
                    return InfoCard(
                      title: 'عدد العروض',
                      value: offerCount.toString(),
                      icon: Icons.discount,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
