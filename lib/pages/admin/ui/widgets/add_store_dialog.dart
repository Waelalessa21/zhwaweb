import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../data/model/store.dart';
import '../../cubit/store_cubit.dart';

class AddStoreDialog extends StatefulWidget {
  const AddStoreDialog({super.key});

  @override
  State<AddStoreDialog> createState() => _AddStoreDialogState();
}

class _AddStoreDialogState extends State<AddStoreDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sectorController = TextEditingController();
  final _cityController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _productsController = TextEditingController();

  String _imagePath = 'assets/images/default-store.png';
  Uint8List? _imageBytes;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildImageSelector(),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                label: 'اسم المتجر',
                validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _sectorController,
                      label: 'القطاع',
                      validator: (value) =>
                          value?.isEmpty == true ? 'مطلوب' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _cityController,
                      label: 'المدينة',
                      validator: (value) =>
                          value?.isEmpty == true ? 'مطلوب' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _locationController,
                label: 'الموقع',
                validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'الوصف',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _addressController,
                label: 'العنوان',
                validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _phoneController,
                      label: 'الهاتف',
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value?.isEmpty == true ? 'مطلوب' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value?.isEmpty == true ? 'مطلوب' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _productsController,
                label: 'المنتجات (مفصولة بفواصل)',
                hintText: 'مثال: لابتوب، هاتف، تابلت',
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'إلغاء',
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'إضافة',
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'صورة المتجر',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.appGreen,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.appGreen, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50],
            ),
            child: _imageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: AppColors.appGreen,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اضغط لاختيار صورة',
                        style: TextStyle(
                          color: AppColors.appGreen,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          setState(() {
            _imageBytes = file.bytes;
            _imagePath = file.name; // Use filename instead of path
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في اختيار الصورة: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() == true) {
      String imageUrl = 'assets/images/default-store.png';

      // Upload image if one is selected
      if (_imageBytes != null) {
        try {
          // For now, we'll use the filename as a placeholder
          // In a real app, you'd upload the image bytes to get a URL
          imageUrl = _imagePath;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في رفع الصورة: $e'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      final store = Store(
        id: '',
        name: _nameController.text,
        sector: _sectorController.text,
        city: _cityController.text,
        location: _locationController.text,
        image: imageUrl,
        description: _descriptionController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        ownerId: '',
        products: _productsController.text
            .split('،')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        isActive: true,
      );

      context.read<StoreCubit>().createStore(store);
      Navigator.pop(context);
    }
  }
}
