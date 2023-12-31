import 'package:flutter/material.dart';
import 'package:male_naturapp/models/product.dart';
import 'package:male_naturapp/pages/products/new_product_page.dart';
import 'package:male_naturapp/pages/products/product_details_page.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({super.key});

  static String title = "Productos";

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  _ProductsPageState() : productService = DefaultProductServiceProvider.getDefaultProductService();

  late final ProductService productService;

  List<Product> _products = [];

  Future<void> _newProduct() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewProductPage()));
    if (result != null && result == true) {
      var products = await productService.getAllProducts();
      setState(() {
        _products = products;
      });
    }
  }

  void _deleteItem(int id) async {
    productService.delete(id);
    var products = await productService.getAllProducts();
    setState(() {
      _products = products;
    });
  }

  void _productDetails(int id) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: id)));
    if (result != null && result == true) {
      var products = await productService.getAllProducts();
      setState(() {
        _products = products;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: ProductsPage.title,
      body: Scaffold(
        body: FutureBuilder<List<Product>>(
          future: productService.getAllProducts(),
          builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            else if (snapshot.hasError) {
              return Text('Error al cargar los datos');
            }
            else {
              _products = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async {
                  var products = await productService.getAllProducts();
                  setState(() {
                    _products = products;
                  });
                  return Future(() => null);
                },
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    itemCount: _products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _productDetails(_products[index].id!);
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Center(child: Text(_products[index].name, style: TextStyle(fontWeight: FontWeight.bold)))),
                                    IconButton(
                                        onPressed: () {
                                          _deleteItem(_products[index].id!);
                                        },
                                        icon: Icon(Icons.delete)),
                                  ],
                                ),
                              ],
                            ),
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
        onPressed: _newProduct,
        child: Icon(Icons.add),
      ),
    );
  }
}