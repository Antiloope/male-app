import 'package:flutter/material.dart';
import 'package:male_naturapp/models/stock_item.dart';
import 'package:male_naturapp/services/stock/stock_service.dart';
import 'package:male_naturapp/services/stock/stock_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';
import 'package:male_naturapp/widgets/form_in_page.dart';

class StockExitPage extends StatefulWidget {
  StockExitPage({super.key});

  static const String title = "Egreso de Stock";

  @override
  _StockExitPageState createState() => _StockExitPageState();
}

class _StockExitPageState extends State<StockExitPage> {
  _StockExitPageState() : stockService = DefaultStockServiceProvider.getDefaultStockService();

  final StockService stockService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();

  StockItem? _selectedStockItem;
  String _selectedItemName = 'Seleccionar producto...';

  void _processStockExit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedStockItem == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor selecciona un producto'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      int exitQuantity = int.parse(_quantityController.text);
      int currentQuantity = _selectedStockItem!.quantity;

      if (exitQuantity > currentQuantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No hay suficiente stock. Cantidad disponible: $currentQuantity'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Actualizar la cantidad restando la cantidad de egreso
      int newQuantity = currentQuantity - exitQuantity;
      await stockService.updateQuantity(_selectedStockItem!.id, newQuantity);

      String message = newQuantity == 0 
        ? 'Stock agotado para ${_selectedStockItem!.name}'
        : 'Egreso registrado. Stock restante: $newQuantity';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: newQuantity == 0 ? Colors.orange : Colors.blue,
        ),
      );
      
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: StockExitPage.title,
      body: FormInPage(
        formKey: _formKey,
        items: [
          // Selector de producto con stock
          FutureBuilder<List<StockItem>>(
            future: stockService.getAllStockItems(),
            builder: (BuildContext context, AsyncSnapshot<List<StockItem>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return DropdownButtonFormField<String>(
                  value: _selectedItemName,
                  items: [DropdownMenuItem<String>(
                    value: _selectedItemName,
                    child: Text(_selectedItemName),
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
                  value: 'No hay productos en stock',
                  items: [DropdownMenuItem<String>(
                    value: 'No hay productos en stock',
                    child: Text('No hay productos en stock'),
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
                // Filtrar solo productos con stock > 0
                List<StockItem> availableStockItems = snapshot.data!
                    .where((item) => item.quantity > 0)
                    .toList();

                if (availableStockItems.isEmpty) {
                  return DropdownButtonFormField<String>(
                    value: 'No hay productos con stock disponible',
                    items: [DropdownMenuItem<String>(
                      value: 'No hay productos con stock disponible',
                      child: Text('No hay productos con stock disponible'),
                    )],
                    onChanged: null,
                    decoration: InputDecoration(
                      labelText: 'Producto',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  );
                }

                return DropdownButtonFormField<StockItem>(
                  value: _selectedStockItem,
                  items: availableStockItems.map((StockItem stockItem) {
                    return DropdownMenuItem<StockItem>(
                      value: stockItem,
                      child: Text('${stockItem.name} (Stock: ${stockItem.quantity})'),
                    );
                  }).toList(),
                  onChanged: (StockItem? newStockItem) {
                    setState(() {
                      _selectedStockItem = newStockItem;
                      _selectedItemName = newStockItem?.name ?? 'Seleccionar producto...';
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Producto',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (StockItem? value) {
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
          
          // Mostrar información del stock seleccionado
          if (_selectedStockItem != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información del Stock',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Producto: ${_selectedStockItem!.name}'),
                  Text('Stock disponible: ${_selectedStockItem!.quantity}'),
                  Text('Precio: \$${_selectedStockItem!.price.toStringAsFixed(2)}'),
                ],
              ),
            ),
          if (_selectedStockItem != null) SizedBox(height: 20),
          
          // Campo de cantidad a egresar
          TextFormField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cantidad a egresar',
              hintText: 'Ej: 10',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.remove_circle_outline),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa la cantidad';
              }
              if (int.tryParse(value) == null || int.parse(value) <= 0) {
                return 'Ingresa una cantidad válida mayor a 0';
              }
              if (_selectedStockItem != null && int.parse(value) > _selectedStockItem!.quantity) {
                return 'Cantidad excede el stock disponible (${_selectedStockItem!.quantity})';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          
          // Campo de motivo (opcional)
          TextFormField(
            controller: _reasonController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Motivo del egreso (opcional)',
              hintText: 'Ej: Venta, Devolución, Merma, etc.',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.note),
            ),
          ),
          SizedBox(height: 30),
          
          // Información de advertencia
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'Advertencia',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• Esta acción reducirá el stock del producto seleccionado\n'
                  '• La operación no se puede deshacer\n'
                  '• Si el stock llega a 0, el producto quedará agotado',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          
          // Botón de procesar egreso
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: _processStockExit,
              icon: Icon(Icons.remove_circle_outline),
              label: Text(
                'Procesar Egreso',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
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