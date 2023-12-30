import 'package:flutter/material.dart';
import 'package:male_naturapp/models/product_category.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';
import 'package:male_naturapp/widgets/form_in_page.dart';

class NewCategoryPage extends StatefulWidget {
  NewCategoryPage({super.key});

  static const String title = "Nueva categoría";

  @override
  _NewCategoryPageState createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  _NewCategoryPageState() : productService = DefaultProductServiceProvider.getDefaultProductService();

  final ProductService productService;
  final _categoryNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _createCategory() {
    if (_formKey.currentState!.validate()) {
      productService.saveCategory(
          ProductCategory(
            name: _categoryNameController.text,
          )
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: NewCategoryPage.title,
      body: FormInPage(
        formKey: _formKey,
        items: [
          TextFormField(
            controller: _categoryNameController,
            decoration: const InputDecoration(
              hintText: 'Nombre',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Para crear una categoria hay que ponerle un nombre';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: _createCategory,
              child: Text('Crear categoría'),
            ),
          ),
        ],
      ),
    );
  }
}