import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  static Icon icon = Icon(Icons.archive);
  static String title = "Stock";

  @override
  Widget build(BuildContext context) {
    return Text('Stock');
  }

}