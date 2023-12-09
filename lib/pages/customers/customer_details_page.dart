import 'package:flutter/material.dart';
import 'package:male_naturapp/models/customer.dart';
import 'package:male_naturapp/services/customer/customer_service.dart';
import 'package:male_naturapp/services/customer/customer_service_provider.dart';

class CustomerDetailsPage extends StatelessWidget {
  CustomerDetailsPage({super.key, required this.customerId}) : customerService = DefaultCustomerServiceProvider.getDefaultCustomerService();

  final int customerId;
  final CustomerService customerService;

  @override
  Widget build(BuildContext context) {
    customerService.getCustomerById(customerId);
    return FutureBuilder<Customer>(
      future: customerService.getCustomerById(customerId),
      builder: (BuildContext context, AsyncSnapshot<Customer> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        else if (snapshot.hasError) {
          return Text('Error al cargar los datos');
        }
        else {
          Customer customer = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold))),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            body: ListView.builder(
              padding: EdgeInsets.all(10),
              itemBuilder: (BuildContext context, int index) {  },

            ),
          );
        }
      },
    );
  }

}