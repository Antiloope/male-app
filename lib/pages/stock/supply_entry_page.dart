import 'package:flutter/material.dart';
import 'package:male_naturapp/models/supply_entry_item.dart';
import 'package:male_naturapp/models/stock_item.dart';
import 'package:male_naturapp/pages/stock/product_selection_page.dart';
import 'package:male_naturapp/services/stock/stock_service.dart';
import 'package:male_naturapp/services/stock/stock_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';
import 'package:male_naturapp/widgets/info_card.dart';
import 'package:male_naturapp/widgets/confirm_dialog.dart';

class SupplyEntryPage extends StatefulWidget {
  const SupplyEntryPage({super.key});

  static const String title = "Carga de existencias";

  @override
  _SupplyEntryPageState createState() => _SupplyEntryPageState();
}

class _SupplyEntryPageState extends State<SupplyEntryPage> {
  late final StockService stockService;
  List<SupplyEntryItem> _entryItems = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    stockService = DefaultStockServiceProvider.getDefaultStockService();
  }

  void _addProduct() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ProductSelectionPage())
    );
    
    if (result != null && result is SupplyEntryItem) {
      setState(() {
        // Verificar si el producto ya está en la lista
        int existingIndex = _entryItems.indexWhere(
          (item) => item.product.id == result.product.id
        );
        
        if (existingIndex >= 0) {
          // Si ya existe, sumar las cantidades
          _entryItems[existingIndex] = SupplyEntryItem(
            product: _entryItems[existingIndex].product,
            quantity: _entryItems[existingIndex].quantity + result.quantity,
          );
        } else {
          // Si no existe, agregarlo a la lista
          _entryItems.add(result);
        }
      });
    }
  }

  void _removeItem(int index) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Eliminar producto',
      content: '¿Estás seguro de que quieres eliminar ${_entryItems[index].product.name} de la lista?',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
    );

    if (confirmed == true) {
      setState(() {
        _entryItems.removeAt(index);
      });
    }
  }

  void _processSupplyEntry() async {
    if (_entryItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Agrega al menos un producto para procesar el ingreso')),
      );
      return;
    }

    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Confirmar carga de existencias',
      content: '¿Estás seguro de que quieres procesar el ingreso de ${_entryItems.length} producto(s) al stock?',
      confirmText: 'Confirmar Ingreso',
      cancelText: 'Cancelar',
    );

    if (confirmed != true) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      for (SupplyEntryItem item in _entryItems) {
        final existingStock = await stockService.getStockItemByProductId(item.product.id!);
        
        if (existingStock != null) {
          await stockService.updateQuantity(existingStock.id, existingStock.quantity + item.quantity);
        } else {
          final newStockItem = StockItem(
            id: 0,
            productId: item.product.id!,
            quantity: item.quantity,
            price: 0.0,
            lastUpdated: DateTime.now(),
            product: item.product,
          );
          await stockService.addStockItem(newStockItem);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Carga de existencias procesada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al procesar el ingreso: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: SupplyEntryPage.title,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.local_shipping,
                  size: 48,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                SizedBox(height: 8),
                Text(
                  'Carga de existencias',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${_entryItems.length} producto(s) agregado(s)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addProduct,
                icon: Icon(Icons.add_shopping_cart),
                label: Text('Agregar Producto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Lista de productos agregados
          Expanded(
            child: _entryItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay productos agregados',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Presiona "Agregar Producto" para comenzar',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _entryItems.length,
                    itemBuilder: (context, index) {
                      final item = _entryItems[index];
                      return InfoCard(
                        title: item.product.name,
                        subtitle: item.product.description,
                        fields: [
                          InfoCardField(
                            value: '${item.quantity} unidades a ingresar',
                            icon: Icons.add_box,
                          ),
                        ],
                        trailing: IconButton(
                          onPressed: () => _removeItem(index),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Botón de confirmar ingreso
          if (_entryItems.isNotEmpty)
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _processSupplyEntry,
                    icon: _isProcessing 
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.check_circle),
                    label: Text(
                      _isProcessing ? 'Procesando...' : 'Confirmar carga de existencias',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
        ],
      ),
    );
  }
} 