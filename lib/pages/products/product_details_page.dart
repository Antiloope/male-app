import 'package:flutter/material.dart';
import 'package:male_naturapp/models/product.dart';
import 'package:male_naturapp/models/product_category.dart';
import 'package:male_naturapp/pages/products/edit_product_page.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({super.key, required this.productId}) : productService = DefaultProductServiceProvider.getDefaultProductService();

  final int productId;
  final ProductService productService;

  void _editItem(BuildContext context, Product product) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProductPage(product: product)));
    if (result != null && result == true) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
        future: productService.getProductById(productId),
        builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          else if (snapshot.hasError) {
            return Text('Error al cargar los datos');
          }
          else {
            Product product = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: Center(child: Text('Detalle', style: TextStyle(fontWeight: FontWeight.bold))),
                backgroundColor: Theme.of(context).colorScheme.primary,
                actions: [IconButton(
                    onPressed: () {
                      _editItem(context, product);
                    },
                    icon: Icon(Icons.edit)),],
              ),
              body: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Card(
                    margin: EdgeInsets.all(6),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Center(child: Text(product.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)))),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                              Column(
                                children: [
                                  Text('Id externo:  ', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(product.externalId.toString()),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              FutureBuilder<ProductCategory>(
                                future: productService.getCategoryById(product.category),
                                builder: (BuildContext context, AsyncSnapshot<ProductCategory> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
                                    return Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text('Categoría:  ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('...'),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                  else {
                                    ProductCategory category = snapshot.data!;
                                    return Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text('Categoría: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(category.name),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                                Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                children: [
                                  Text(product.description),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(6),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Center(child: Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
    );
  }
}