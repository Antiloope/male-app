import 'package:flutter/material.dart';
import 'package:male_naturapp/models/customer.dart';
import 'package:male_naturapp/services/customer/customer_service.dart';
import 'package:male_naturapp/services/customer/customer_service_provider.dart';

class NewCustomerPage extends StatefulWidget {
  NewCustomerPage({super.key});

  @override
  _NewCustomerPageState createState() => _NewCustomerPageState();
}

class _NewCustomerPageState extends State<NewCustomerPage> {
  _NewCustomerPageState() : customerService = DefaultCustomerServiceProvider.getDefaultCustomerService();

  late final CustomerService customerService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  void _createCustomer() {
    if (_formKey.currentState!.validate()) {
      customerService.save(
          Customer(
            name: _nameController.text,
            phone: int.parse(_phoneController.text),
          )
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Nuevo cliente', style: TextStyle(fontWeight: FontWeight.bold))),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white60,
        child: Form(
          key: _formKey,
          child:
            Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre',
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
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Teléfono',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Introduce un número válido';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: _createCustomer,
                    child: Text('Crear usuario'),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

}