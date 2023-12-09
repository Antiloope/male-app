import 'package:flutter/material.dart';
import 'package:male_naturapp/pages/root_page.dart';
import 'package:male_naturapp/utils/database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Male Naturapp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF94C9A9),
          secondary: Color(0xFFFCB97D),
        ),
        useMaterial3: true,
      ),
      home: const RootPage(),
    );
  }
}
