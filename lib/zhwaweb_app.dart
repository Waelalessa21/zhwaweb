import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/login/ui/login_screen.dart';
import 'core/router/app_router.dart';
import 'core/theming/app_colors.dart';
import 'core/services/api_service.dart';
import 'core/services/auth_manager.dart';
import 'pages/admin/cubit/store_cubit.dart';
import 'pages/admin/cubit/offer_cubit.dart';
import 'pages/admin/cubit/subscription_cubit.dart';
import 'pages/admin/ui/admin_screen.dart';

class ZhwawebApp extends StatefulWidget {
  const ZhwawebApp({super.key});

  @override
  State<ZhwawebApp> createState() => _ZhwawebAppState();
}

class _ZhwawebAppState extends State<ZhwawebApp> {
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    ApiService().initialize();
    await AuthManager().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => StoreCubit()),
        BlocProvider(create: (context) => OfferCubit()),
        BlocProvider(create: (context) => SubscriptionCubit()),
      ],
      child: MaterialApp(
        title: 'زهوة',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'TheYearofHandicrafts',
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
        ),
        locale: const Locale('ar', 'SA'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: AuthManager().isLoggedIn
            ? const AdminPage()
            : const LoginScreen(),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
