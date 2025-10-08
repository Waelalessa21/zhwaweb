import 'package:flutter/material.dart';
import 'package:zhwaweb/core/widgets/custom_text_field.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/services/auth_manager.dart';
import '../../../admin/ui/admin_screen.dart';
import '../../../admin/ui/widgets/store_subscription_dialog.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomTextField(
            controller: _usernameController,
            label: 'اسم المستخدم',
            validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            label: 'كلمة المرور',
            validator: (value) => value?.isEmpty == true ? 'مطلوب' : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('تسجيل الدخول', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: _handleSubscription,
              child: const Text(
                'إشتراك',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() => _isLoading = true);

      final result = await AuthManager().login(
        _usernameController.text,
        _passwordController.text,
      );

      result.when(
        success: (data) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminPage()),
          );
        },
        failure: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في تسجيل الدخول: $message'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );

      setState(() => _isLoading = false);
    }
  }

  void _handleSubscription() {
    showDialog(
      context: context,
      builder: (context) => const StoreSubscriptionDialog(),
    );
  }
}
