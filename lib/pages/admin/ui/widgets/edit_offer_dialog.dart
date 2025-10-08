import 'package:flutter/material.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';

class EditOfferDialog extends StatefulWidget {
  final Map<String, dynamic> offer;

  const EditOfferDialog({super.key, required this.offer});

  @override
  State<EditOfferDialog> createState() => _EditOfferDialogState();
}

class _EditOfferDialogState extends State<EditOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _discountController;
  late final TextEditingController _imageController;
  late DateTime _selectedDate;
  String? _selectedStore;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.offer['title'] ?? '');
    _descriptionController = TextEditingController(
      text: widget.offer['description'] ?? '',
    );
    _discountController = TextEditingController(
      text: widget.offer['discount']?.toString() ?? '',
    );
    _imageController = TextEditingController(text: widget.offer['image'] ?? '');
    _selectedDate = widget.offer['validUntil'] != null
        ? DateTime.parse(widget.offer['validUntil'])
        : DateTime.now().add(const Duration(days: 30));
    _selectedStore = widget.offer['storeId'];
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
              const Text(
                'تعديل العرض',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.appGreen,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _titleController,
                label: 'عنوان العرض',
                validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
                isUpdate: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'وصف العرض',
                maxLines: 3,
                validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
                isUpdate: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      isUpdate: true,
                      controller: _discountController,
                      label: 'نسبة الخصم (%)',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return 'مطلوب';
                        final discount = int.tryParse(value ?? '');
                        if (discount == null ||
                            discount <= 0 ||
                            discount > 100) {
                          return 'يجب أن تكون بين 1 و 100';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedStore,
                      decoration: InputDecoration(
                        labelText: 'المتجر',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.appGreen,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'store1',
                          child: Text('متجر الأزياء الحديثة'),
                        ),
                        DropdownMenuItem(
                          value: 'store2',
                          child: Text('متجر الإلكترونيات'),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedStore = value),
                      validator: (value) => value == null ? 'مطلوب' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                isUpdate: true,
                controller: _imageController,
                label: 'رابط الصورة',
                hintText: 'https://example.com/image.jpg',
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.appGreen,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'صالح حتى: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
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

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() == true) {
      Navigator.pop(context);
    }
  }
}
