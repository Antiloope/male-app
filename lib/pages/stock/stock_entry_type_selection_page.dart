import 'package:flutter/material.dart';
import 'package:male_naturapp/pages/stock/supply_entry_page.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';

class StockEntryTypeSelectionPage extends StatelessWidget {
  const StockEntryTypeSelectionPage({super.key});

  static const String title = "Tipo de Ingreso";

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: title,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            // Botón Pedido de ciclo
            _buildEntryTypeButton(
              context: context,
              title: 'Pedido de ciclo',
              subtitle: 'Ingreso por nuevo pedido de ciclo',
              icon: Icons.schedule,
              color: Colors.blue,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pedido de ciclo - Por implementar')),
                );
              },
            ),
            SizedBox(height: 16),
            
            // Botón Regalo
            _buildEntryTypeButton(
              context: context,
              title: 'Regalo',
              subtitle: 'Productos recibidos como obsequio',
              icon: Icons.card_giftcard,
              color: Colors.purple,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Regalo - Por implementar')),
                );
              },
            ),
            SizedBox(height: 16),
            
            // Botón Suministro
            _buildEntryTypeButton(
              context: context,
              title: 'Existencias',
              subtitle: 'Carga de productos ya existentes en el stock',
              icon: Icons.local_shipping,
              color: Colors.green,
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SupplyEntryPage())
                );
                if (result != null && result == true) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
            SizedBox(height: 16),
            
            // Botón Ajuste
            _buildEntryTypeButton(
              context: context,
              title: 'Ajuste',
              subtitle: 'Corrección de inventario',
              icon: Icons.tune,
              color: Colors.orange,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ajuste - Por implementar')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryTypeButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 