import 'package:flutter/material.dart';
import 'package:male_naturapp/models/stock_item.dart';
import 'package:male_naturapp/models/product.dart';
import 'package:male_naturapp/services/stock/stock_service.dart';
import 'package:male_naturapp/services/stock/stock_service_provider.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';
import 'package:male_naturapp/widgets/form_in_page.dart';

class NewStockEntryPage extends StatefulWidget {
  NewStockEntryPage({super.key});

  static const String title = "Ingreso de Stock";

  @override
  _NewStockEntryPageState createState() => _NewStockEntryPageState();
}

class _NewStockEntryPageState extends State<NewStockEntryPage> {
  _NewStockEntryPageState() : 
    stockService = DefaultStockServiceProvider.getDefaultStockService(),
    productService = DefaultProductServiceProvider.getDefaultProductService();

  final StockService stockService;
  final ProductService productService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  Product? _selectedProduct;
  String _selectedProductName = 'Seleccionar producto...';

  void _createStockEntry() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedProduct == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor selecciona un producto'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Verificar si ya existe stock para este producto
      StockItem? existingStock = await stockService.getStockItemByProductId(_selectedProduct!.id!);
      
      if (existingStock != null) {
        // Si ya existe, actualizar cantidad sumando la nueva cantidad
        int newTotalQuantity = existingStock.quantity + int.parse(_quantityController.text);
        await stockService.updateQuantity(existingStock.id, newTotalQuantity);
        await stockService.updatePrice(existingStock.id, double.parse(_priceController.text));
      } else {
        // Si no existe, crear nuevo item de stock
        StockItem newStockItem = StockItem(
          id: 0, // Se generará automáticamente
          productId: _selectedProduct!.id!,
          quantity: int.parse(_quantityController.text),
          price: double.parse(_priceController.text),
          lastUpdated: DateTime.now(),
          product: _selectedProduct,
        );
        await stockService.addStockItem(newStockItem);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stock ingresado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: NewStockEntryPage.title,
      body: FormInPage(
        formKey: _formKey,
        items: [
          // Selector de producto
          FutureBuilder<List<Product>>(
            future: productService.getAllProducts(),
            builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return DropdownButtonFormField<String>(
                  value: _selectedProductName,
                  items: [DropdownMenuItem<String>(
                    value: _selectedProductName,
                    child: Text(_selectedProductName),
                  )],
                  onChanged: null,
                  decoration: InputDecoration(
                    labelText: 'Producto',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                );
              }
              else if (snapshot.hasError || snapshot.data!.isEmpty) {
                return DropdownButtonFormField<String>(
                  value: 'Error al cargar productos',
                  items: [DropdownMenuItem<String>(
                    value: 'Error al cargar productos',
                    child: Text('Error al cargar productos'),
                  )],
                  onChanged: null,
                  decoration: InputDecoration(
                    labelText: 'Producto',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                );
              }
              else {
                List<Product> products = snapshot.data!;
                return DropdownButtonFormField<Product>(
                  value: _selectedProduct,
                  items: products.map((Product product) {
                    return DropdownMenuItem<Product>(
                      value: product,
                      child: Text(product.name),
                    );
                  }).toList(),
                  onChanged: (Product? newProduct) {
                    setState(() {
                      _selectedProduct = newProduct;
                      _selectedProductName = newProduct?.name ?? 'Seleccionar producto...';
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Producto',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (Product? value) {
                    if (value == null) {
                      return 'Por favor selecciona un producto';
                    }
                    return null;
                  },
                );
              }
            },
          ),
          SizedBox(height: 20),
          
          // Campo de cantidad
          TextFormField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cantidad a ingresar',
              hintText: 'Ej: 50',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.inventory),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa la cantidad';
              }
              if (int.tryParse(value) == null || int.parse(value) <= 0) {
                return 'Ingresa una cantidad válida mayor a 0';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          
          // Campo de precio
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Precio unitario',
              hintText: 'Ej: 15.50',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el precio';
              }
              if (double.tryParse(value) == null || double.parse(value) <= 0) {
                return 'Ingresa un precio válido mayor a 0';
              }
              return null;
            },
          ),
          SizedBox(height: 30),
          
          // Información adicional
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                    SizedBox(width: 8),
                    Text(
                      'Información',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• Si el producto ya tiene stock, se sumará la cantidad ingresada\n'
                  '• El precio se actualizará al valor ingresado\n'
                  '• La fecha de última actualización se registrará automáticamente',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          
          // Botón de crear
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: _createStockEntry,
              icon: Icon(Icons.add_box),
              label: Text(
                'Ingresar Stock',
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 