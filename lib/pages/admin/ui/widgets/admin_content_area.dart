import 'package:flutter/material.dart';
import 'dashboard_section.dart';
import 'stores_section.dart';
import 'offers_section.dart';
import 'requests_section.dart';

class AdminContentArea extends StatelessWidget {
  final int selectedOption;

  const AdminContentArea({super.key, required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: 4, child: _buildContentArea());
  }

  Widget _buildContentArea() {
    switch (selectedOption) {
      case 0:
        return const DashboardSection();
      case 1:
        return const StoresSection();
      case 2:
        return const OffersSection();
      case 3:
        return const RequestsSection();
      default:
        return const DashboardSection();
    }
  }
}
