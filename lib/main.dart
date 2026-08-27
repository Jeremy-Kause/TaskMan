import 'package:flutter/material.dart';
import 'database/sqlite/sqlite_helper.dart';
import 'presentations/main_nav_pres.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ponytail: inisialisasi DB & pastikan data dummy terisi
  await SqliteHelper.instance.seedIfEmpty();
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
