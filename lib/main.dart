import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:psicoapp/theme/app_theme.dart';
import 'package:psicoapp/utils/constants.dart';
import 'package:psicoapp/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(const PsicoApp());
}

class PsicoApp extends StatelessWidget {
  const PsicoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
