import 'package:flutter/material.dart';

class DataListView<T> extends StatelessWidget {
  final Future<List<T>> future;
  final List<T> filteredItems;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final VoidCallback onRefresh;
  final String errorMessage;

  const DataListView({
    super.key,
    required this.future,
    required this.filteredItems,
    required this.itemBuilder,
    required this.onRefresh,
    this.errorMessage = 'Error al cargar los datos',
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<T>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasError) {
          return Center(child: Text(errorMessage));
        }
        else {
          return RefreshIndicator(
            onRefresh: () async {
              onRefresh();
              return Future(() => null);
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              itemCount: filteredItems.length,
              itemBuilder: (BuildContext context, int index) {
                return itemBuilder(context, index, filteredItems[index]);
              },
            ),
          );
        }
      },
    );
  }
} 