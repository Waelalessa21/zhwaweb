import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../../../../core/theming/app_colors.dart';
import '../../../../data/model/store.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../cubit/store_cubit.dart';

class EditStoreDialog extends StatefulWidget {
  final Store store;

  const EditStoreDialog({super.key, required this.store});

  @override
  State<EditStoreDialog> createState() => _EditStoreDialogState();
}

class _EditStoreDialogState extends State<EditStoreDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _sectorController;
  late final TextEditingController _cityController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _productsController;

  String _imagePath = '';
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.store.name);
    _sectorController = TextEditingController(text: widget.store.sector);
    _cityController = TextEditingController(text: widget.store.city);
    _locationController = TextEditingController(text: widget.store.location);
    _descriptionController = TextEditingController(
      text: widget.store.description,
    );
    _addressController = TextEditingController(text: widget.store.address);
    _phoneController = TextEditingController(text: widget.store.phone);
    _emailController = TextEditingController(text: widget.store.email);
    _productsController = TextEditingController(
      text: widget.store.products.join('، '),
    );
    _imagePath = widget.store.image;
  }

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
                isUpdate: true,
                controller: _nameController,
                label: 'اسم المتجر',
                validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      isUpdate: true,
                      controller: _sectorController,
                      label: 'القطاع',
                      validator: (value) =>
                          value?.isEmpty == true ? 'مطلوب' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      isUpdate: true,
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
                isUpdate: true,
                controller: _locationController,
                label: 'الموقع',
                validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                isUpdate: true,
                controller: _descriptionController,
                label: 'الوصف',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                isUpdate: true,
                controller: _addressController,
                label: 'العنوان',
                validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      isUpdate: true,
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
                      isUpdate: true,
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
                isUpdate: true,
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
                      'تحديث',
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
                : _imagePath.startsWith('assets/')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(_imagePath, fit: BoxFit.cover),
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
                        'اضغط لاختيار صورة جديدة',
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

  void _handleSubmit() {
    if (_formKey.currentState?.validate() == true) {
      final updatedStore = widget.store.copyWith(
        name: _nameController.text,
        sector: _sectorController.text,
        city: _cityController.text,
        location: _locationController.text,
        image: _imagePath,
        description: _descriptionController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        products: _productsController.text
            .split('،')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      );

      context.read<StoreCubit>().updateStore(updatedStore);
      Navigator.pop(context);
    }
  }
}
