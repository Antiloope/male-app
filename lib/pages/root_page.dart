import 'package:flutter/material.dart';
import 'package:male_naturapp/pages/finances_page.dart';
import 'package:male_naturapp/pages/stock_page.dart';
import 'home_page.dart';

enum Page {
  stock,
  home,
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
      case Page.stock:
        _setCurrentPage(StockPage());
        _setTitle(StockPage.title);
      case Page.home:
        _setCurrentPage(HomePage());
        _setTitle(HomePage.title);
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
        title: Center(child: Text(_title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary))),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).colorScheme.onSecondary,
        selectedItemColor: Theme.of(context).colorScheme.onSecondary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: StockPage.icon,
            label: StockPage.title,
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: HomePage.icon,
            label: HomePage.title,
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: FinancesPage.icon,
            label: FinancesPage.title,
          ),
        ],
        onTap: _switchPage,
      ),
    );
  }
}