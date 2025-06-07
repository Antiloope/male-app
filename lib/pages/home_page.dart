import 'package:flutter/material.dart';
import 'package:male_naturapp/pages/customers/customers_page.dart';
import 'package:male_naturapp/pages/products/products_page.dart';
import 'package:male_naturapp/widgets/grid_button.dart';

import 'products/categories/categories_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Icon icon = Icon(Icons.home);
  static String title = "Home";
  static String welcomeMessage = "Buen día Male!";

  List<Widget> _generateQuickAccessList(BuildContext context) {
    return [
      GridButton(text: "Clientes", icon: Icon(Icons.person), page: CustomersPage()),
      GridButton(text: "Productos", icon: Icon(Icons.data_array), page: ProductsPage()),
      GridButton(text: "Categorías", icon: Icon(Icons.collections_bookmark), page: CategoriesPage()),
    ];
  }

  List<Widget> _generateHomeWidgets(BuildContext context) {
    final quickAccessList = _generateQuickAccessList(context);
    return [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text(
          welcomeMessage,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),  
      Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color(0xFFFCEEEE),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 8,
                offset: Offset(1,1),
              )
            ]
        ),
        child: GridView.count(
          crossAxisCount: 4,
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: quickAccessList,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final homeWidgets = _generateHomeWidgets(context);
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: homeWidgets,
      ),
    );
  }

}