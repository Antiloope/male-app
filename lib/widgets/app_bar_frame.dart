import 'package:flutter/material.dart';

class AppBarFrame extends StatelessWidget {
  AppBarFrame({super.key, required this.title, this.body, this.floatingActionButton});

  final String title;
  final Widget? body;
  final FloatingActionButton? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold)
          )
        ),
        backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}