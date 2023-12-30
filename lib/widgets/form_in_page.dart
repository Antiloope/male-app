import 'package:flutter/cupertino.dart';

class FormInPage extends StatelessWidget {
  FormInPage({super.key, required this.items, required this.formKey});

  final GlobalKey<FormState>? formKey;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: formKey,
        child: Column(
          children: items,
        ),
      )
    );
  }

}