import 'package:flutter/material.dart';
import 'package:male_naturapp/models/product.dart';
import 'package:male_naturapp/models/product_category.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';
import 'package:male_naturapp/widgets/form_in_page.dart';

class NewProductPage extends StatefulWidget {
  NewProductPage({super.key});

  static const String title = "Nuevo producto";

  @override
  _NewProductPageState createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  _NewProductPageState() : productService = DefaultProductServiceProvider.getDefaultProductService();
  
  final ProductService productService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _productExternalIdController = TextEditingController();

  void _createProduct() async {
    if (_formKey.currentState!.validate()) {
      ProductCategory? category = await productService.getCategoryByName(_selectedValue);

      productService.save(
          Product(
            name: _productNameController.text,
            externalId: _productExternalIdController.text,
            description: _productDescriptionController.text,
            category: category!.id!,
          )
      );
      Navigator.of(context).pop(true);
    }
  }

  String _selectedValue = 'Cargando...';

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: NewProductPage.title,
      body: FormInPage(
        formKey: _formKey,
        items: [
          TextFormField(
            controller: _productNameController,
            decoration: const InputDecoration(
              hintText: 'Nombre',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Para crear un producto hay que ponerle un nombre';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            maxLines: 10,
            minLines: 1,
            controller: _productDescriptionController,
            decoration: const InputDecoration(
              hintText: 'Descripción',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder<List<ProductCategory>>(
            future: productService.getAllCategories(),
            builder: (BuildContext context, AsyncSnapshot<List<ProductCategory>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError || snapshot.data!.isEmpty) {
                return DropdownButtonFormField(
                  value: _selectedValue,
                  items: <String>[_selectedValue]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                );
              }
              else {
                List<ProductCategory> categories = snapshot.data!;
                _selectedValue = categories[0].name;
                return DropdownButtonFormField(
                  value: _selectedValue,
                  items: categories.map((ProductCategory e){
                    return DropdownMenuItem<String>(
                      value: e.name,
                      child: Text(e.name),
                    );
                  }).toList(),
                  onChanged: (newValue) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                );
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _productExternalIdController,
            decoration: const InputDecoration(
              hintText: 'ID externo',
            ),
            keyboardType: TextInputType.visiblePassword,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: _createProduct,
              child: Text('Crear producto', style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),),
            ),
          ),
        ],
      ),
    );
  }
}