import 'package:flutter/material.dart';
import 'package:male_naturapp/pages/finances_page.dart';
import 'package:male_naturapp/pages/sales_page.dart';
import 'package:male_naturapp/pages/stock_page.dart';
import 'home_page.dart';
import 'customers_page.dart';

enum Page {
  clients,
  stock,
  home,
  sales,
  finances
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late String _title;
  int _currentIndex = Page.home.index;
  Widget _currentPage = HomePage();

  void _setTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  void _setCurrentPage(Widget page) {
    setState(() {
      _currentPage = page;
    });
  }
  
  void _setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _switchPage(int value) {
    Page page = Page.values[value];
    _setCurrentIndex(value);
    switch(page) {
      case Page.clients:
        _setCurrentPage(CustomersPage());
        _setTitle(CustomersPage.title);
      case Page.stock:
        _setCurrentPage(StockPage());
        _setTitle(StockPage.title);
      case Page.home:
        _setCurrentPage(HomePage());
        _setTitle(HomePage.title);
      case Page.sales:
        _setCurrentPage(SalesPage());
        _setTitle(SalesPage.title);
      case Page.finances:
        _setCurrentPage(FinancesPage());
        _setTitle(FinancesPage.title);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _switchPage(_currentIndex);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(_title, style: TextStyle(fontWeight: FontWeight.bold))),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            icon: CustomersPage.icon,
            label: CustomersPage.title,
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            icon: StockPage.icon,
            label: StockPage.title,
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            icon: HomePage.icon,
            label: HomePage.title,
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            icon: SalesPage.icon,
            label: SalesPage.title,
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            icon: FinancesPage.icon,
            label: FinancesPage.title,
          ),
        ],
        onTap: _switchPage,
      ),
    );
  }

}