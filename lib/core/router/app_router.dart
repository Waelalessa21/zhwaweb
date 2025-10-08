import 'package:flutter/material.dart';
import '../constants/arabic_strings.dart';
import '../../pages/login/ui/login_screen.dart';
import '../../pages/admin/ui/admin_screen.dart';
import '../../pages/store/ui/store_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminPage());
      case '/store':
        return MaterialPageRoute(builder: (_) => const StorePage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text(ArabicStrings.pageNotFound)),
          ),
        );
    }
  }
}
