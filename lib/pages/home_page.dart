import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Icon icon = Icon(Icons.home);
  static String title = "Home";

  @override
  Widget build(BuildContext context) {
    return Text('Home');
  }

}