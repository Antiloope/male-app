import 'package:flutter/material.dart';
import 'package:male_naturapp/pages/customers/customers_page.dart';
import 'package:male_naturapp/pages/products/products_page.dart';
import 'package:male_naturapp/widgets/grid_button.dart';

import 'products/categories/categories_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Icon icon = Icon(Icons.home);
  static String title = "Home";

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
      Flexible(
        flex: 1,
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 8,
                  offset: Offset(2,2),
                )
              ]
          ),
          child: GridView.count(
            crossAxisCount: 4,
            padding: EdgeInsets.all(8),
            children: quickAccessList,
          ),
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