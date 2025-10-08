import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../data/model/subscription.dart';
import '../../cubit/subscription_cubit.dart';

class StoreSubscriptionDialog extends StatefulWidget {
  const StoreSubscriptionDialog({super.key});

  @override
  State<StoreSubscriptionDialog> createState() =>
      _StoreSubscriptionDialogState();
}

class _StoreSubscriptionDialogState extends State<StoreSubscriptionDialog> {
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
  void dispose() {
    _nameController.dispose();
    _sectorController.dispose();
    _cityController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _productsController.dispose();
    super.dispose();
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
              const SizedBox(height: 24),
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
                      'إرسال الطلب',
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
            _imagePath = file.name;
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

      if (_imageBytes != null) {
        try {
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

      final subscription = Subscription(
        id: '',
        name: _nameController.text,
        sector: _sectorController.text,
        city: _cityController.text,
        location: _locationController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        products: _productsController.text
            .split('،')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        status: 'pending',
        image: imageUrl,
        description: _descriptionController.text,
      );

      context.read<SubscriptionCubit>().createSubscription(subscription);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال طلب الاشتراك بنجاح. سيتم مراجعته قريباً'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }
}
