import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Eliminar',
    this.cancelText = 'Cancelar',
    this.confirmColor,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Eliminar',
    String cancelText = 'Cancelar',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => ConfirmDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            cancelText,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            confirmText,
            style: TextStyle(color: confirmColor ?? Colors.red)
          ),
        ),
      ],
    );
  }
} 