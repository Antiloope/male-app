import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  static Icon icon = Icon(Icons.sell);
  static String title = "Ventas";

  @override
  Widget build(BuildContext context) {
    return Text('Sales');
  }

}