import 'package:flutter/material.dart';
import 'presentations/mainNavPres.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskmanApp());
}

class TaskmanApp extends StatelessWidget {
  const TaskmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taksman',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavPres(),
    );
  }
}
