import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../data/model/subscription.dart';
import '../../../../data/model/store.dart';
import '../../cubit/subscription_cubit.dart';
import '../../cubit/store_cubit.dart';

class SubscriptionApprovalDialog extends StatefulWidget {
  final Subscription subscription;

  const SubscriptionApprovalDialog({super.key, required this.subscription});

  @override
  State<SubscriptionApprovalDialog> createState() =>
      _SubscriptionApprovalDialogState();
}

class _SubscriptionApprovalDialogState
    extends State<SubscriptionApprovalDialog> {
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subscription.name);
    _sectorController = TextEditingController(text: widget.subscription.sector);
    _cityController = TextEditingController(text: widget.subscription.city);
    _locationController = TextEditingController(
      text: widget.subscription.location,
    );
    _descriptionController = TextEditingController(
      text: widget.subscription.description ?? '',
    );
    _addressController = TextEditingController(
      text: widget.subscription.address,
    );
    _phoneController = TextEditingController(text: widget.subscription.phone);
    _emailController = TextEditingController(text: widget.subscription.email);
    _productsController = TextEditingController(
      text: widget.subscription.products.join('، '),
    );
    _imagePath = widget.subscription.image ?? '';
  }

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
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleReject,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'رفض',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleApprove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('موافقة وإنشاء المتجر'),
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
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.appGreen, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: _imagePath.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(_imagePath, fit: BoxFit.cover),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.store, size: 40, color: AppColors.appGreen),
                    const SizedBox(height: 8),
                    Text(
                      'صورة المتجر',
                      style: TextStyle(color: AppColors.appGreen, fontSize: 14),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  void _handleApprove() {
    if (_formKey.currentState?.validate() == true) {
      final newStore = Store(
        id: '',
        name: _nameController.text,
        sector: _sectorController.text,
        city: _cityController.text,
        location: _locationController.text,
        image: _imagePath,
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

      context.read<SubscriptionCubit>().approveSubscription(
        widget.subscription.id,
      );
      context.read<StoreCubit>().createStore(newStore);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم الموافقة على طلب الاشتراك وإنشاء المتجر "${newStore.name}"',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  void _handleReject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'تأكيد الرفض',
          style: TextStyle(color: Colors.red),
          textDirection: TextDirection.rtl,
        ),
        content: Text(
          'هل أنت متأكد من رفض طلب الاشتراك لـ "${widget.subscription.name}"؟',
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
              context.read<SubscriptionCubit>().rejectSubscription(
                widget.subscription.id,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم رفض طلب الاشتراك لـ "${widget.subscription.name}"',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('رفض'),
          ),
        ],
      ),
    );
  }
}
