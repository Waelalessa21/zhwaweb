import 'package:flutter/material.dart';
import '../../../core/theming/app_colors.dart';
import 'widgets/admin_header.dart';
import 'widgets/admin_sidebar.dart';
import 'widgets/admin_content_area.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AdminHeader(
        onAddPressed: _handleAdd,
        onEditPressed: _handleEdit,
        onDeletePressed: _handleDelete,
      ),
      body: Row(
        children: [
          AdminContentArea(selectedOption: _selectedOption),
          AdminSidebar(
            selectedOption: _selectedOption,
            onOptionSelected: _handleOptionSelected,
          ),
        ],
      ),
    );
  }

  void _handleOptionSelected(int index) {
    setState(() {
      _selectedOption = index;
    });
  }

  void _handleAdd() {}

  void _handleEdit() {}

  void _handleDelete() {}
}
