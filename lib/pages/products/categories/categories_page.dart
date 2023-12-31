
import 'package:flutter/material.dart';
import 'package:male_naturapp/models/product_category.dart';
import 'package:male_naturapp/pages/products/categories/edit_category_page.dart';
import 'package:male_naturapp/pages/products/categories/new_category_page.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({super.key});

  static String title = "Categorías";

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  _CategoriesPageState() : productService = DefaultProductServiceProvider.getDefaultProductService();

  late final ProductService productService;

  List<ProductCategory> _categories = [];

  Future<void> _newCategory() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewCategoryPage()));
    if (result != null && result == true) {
      var categories = await productService.getAllCategories();
      setState(() {
        _categories = categories;
      });
    }
  }

  void _deleteItem(int id) async {
    productService.deleteCategory(id);
    var categories = await productService.getAllCategories();
    setState(() {
      _categories = categories;
    });
  }

  void _editItem(ProductCategory category) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditCategoryPage(category)));
    if (result != null && result == true) {
      var categories = await productService.getAllCategories();
      setState(() {
        _categories = categories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: CategoriesPage.title,
      body: Scaffold(
        body: FutureBuilder<List<ProductCategory>>(
          future: productService.getAllCategories(),
          builder: (BuildContext context, AsyncSnapshot<List<ProductCategory>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            else if (snapshot.hasError) {
              return Text('Error al cargar los datos');
            }
            else {
              _categories = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async {
                  var categories = await productService.getAllCategories();
                  setState(() {
                    _categories = categories;
                  });
                  return Future(() => null);
                },
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    itemCount: _categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30,8,8,8),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(_categories[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                              IconButton(
                                  onPressed: () {
                                    _editItem(_categories[index]);
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    _deleteItem(_categories[index].id!);
                                  },
                                  icon: Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newCategory,
        child: Icon(Icons.add),
      ),
    );
  }

}