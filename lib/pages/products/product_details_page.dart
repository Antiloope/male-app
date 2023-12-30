import 'package:flutter/cupertino.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({super.key, required this.productId}) : productService = DefaultProductServiceProvider.getDefaultProductService();

  final int productId;
  final ProductService productService;

  @override
  Widget build(BuildContext context) {
    return Text("Detalle del producto");
  }
}