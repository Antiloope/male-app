import 'package:flutter/material.dart';
import 'confirm_dialog.dart';

class DismissibleListItem extends StatelessWidget {
  final String itemId;
  final String itemName;
  final String deleteTitle;
  final String deleteMessage;
  final VoidCallback onDelete;
  final Widget child;
  final String deleteSuccessMessage;

  const DismissibleListItem({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.deleteTitle,
    required this.deleteMessage,
    required this.onDelete,
    required this.child,
    required this.deleteSuccessMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(itemId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await ConfirmDialog.show(
          context: context,
          title: deleteTitle,
          content: deleteMessage,
        );
      },
      onDismissed: (direction) {
        onDelete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(deleteSuccessMessage),
            backgroundColor: Colors.red,
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 28),
            Text('Eliminar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      child: child,
    );
  }
} 