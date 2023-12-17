import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Icon icon = Icon(Icons.home);
  static String title = "Home";

  List<Widget> _generateQuickAccessList(BuildContext context) {
    return [
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(60),
                blurRadius: 5,
                offset: Offset(2,2),
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person),
            Text("Clientes"),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 5,
              offset: Offset(2,2),
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.data_array),
            Text("Productos"),
          ],
        ),
      ),
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