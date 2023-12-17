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
        colorScheme: ColorScheme(
          primary: Color(0xFFFFBE98),
          onPrimary: Color(0xFF545677),
          secondary: Color(0xFFBCD8C1),
          onSecondary: Color(0xFF545677),
          error: Color(0xFFD46161),
          onError: Color(0xFF041B15),
          background: Color(0xFFF9E5E0),
          onBackground: Color(0xFF041B15),
          surface: Color(0xFFFFD0BB),
          onSurface: Color(0xFF545677),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const RootPage(),
    );
  }
}
