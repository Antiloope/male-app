
import 'package:flutter/material.dart';
import 'package:male_naturapp/models/product_category.dart';
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
                    padding: EdgeInsets.symmetric(vertical: 3),
                    itemCount: _categories.length,
                    prototypeItem: SizedBox(
                      height: 50,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 50,
                        child: Card(
                          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(_categories[index].name)),
                              Expanded(
                                child: IconButton(
                                    onPressed: () {
                                      _deleteItem(_categories[index].id!);
                                    },
                                    icon: Icon(Icons.delete)),
                              ),
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