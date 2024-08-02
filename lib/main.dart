import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_budget/custom_widgets/colors.dart';
import 'package:personal_budget/firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Budgeting App',
      theme: ThemeData(
        primaryColor: AppColors.secondary,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.secondary,
          background: AppColors.secondary,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.darkText),
          bodyMedium: TextStyle(color: AppColors.darkText),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
