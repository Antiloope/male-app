import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FinancesPage extends StatelessWidget {
  const FinancesPage({super.key});

  static Icon icon = Icon(Icons.bar_chart);
  static String title = "Finanzas";

  @override
  Widget build(BuildContext context) {
    return Text('Finances');
  }

}