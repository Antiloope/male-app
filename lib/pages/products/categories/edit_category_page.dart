import 'package:flutter/material.dart';
import 'package:male_naturapp/models/product_category.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';
import 'package:male_naturapp/widgets/form_in_page.dart';

class EditCategoryPage extends StatefulWidget {
  final ProductCategory category;
  static const String title = "Editar categoría";

  EditCategoryPage(this.category, {super.key});

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  _EditCategoryPageState() : productService = DefaultProductServiceProvider.getDefaultProductService();

  final ProductService productService;
  final _categoryNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _editCategory() {
    if (_formKey.currentState!.validate()) {
      productService.editCategory(
          widget.category.id!,
          _categoryNameController.text
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _categoryNameController.text = widget.category.name;
    return AppBarFrame(
      title: EditCategoryPage.title,
      body: FormInPage(
        formKey: _formKey,
        items: [
          TextFormField(
            controller: _categoryNameController,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Para editar una categoria hay que ponerle un nombre';
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
              onPressed: _editCategory,
              child: Text('Finalizar edición', style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
            ),
          ),
        ],
      ),
    );
  }
}