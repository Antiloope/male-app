import 'package:flutter/material.dart';
import 'package:male_naturapp/models/customer.dart';
import 'package:male_naturapp/pages/customers/customer_details_page.dart';
import 'package:male_naturapp/pages/customers/new_customer_page.dart';
import 'package:male_naturapp/services/customer/customer_service.dart';
import 'package:male_naturapp/services/customer/customer_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';
import 'package:male_naturapp/widgets/custom_search_bar.dart';
import 'package:male_naturapp/widgets/filter_sort_row.dart';
import 'package:male_naturapp/widgets/dismissible_list_item.dart';
import 'package:male_naturapp/widgets/info_card.dart';

class CustomersPage extends StatefulWidget {
  CustomersPage({super.key});
  
  static const Icon icon = Icon(Icons.person);
  static const String title = "Clientes";

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  _CustomersPageState() : customerService = DefaultCustomerServiceProvider.getDefaultCustomerService();
  
  late final CustomerService customerService;
  List<Customer> _allCustomers = [];
  List<Customer> _filteredCustomers = [];
  String _searchQuery = '';
  String _sortBy = 'name'; // name, phone
  bool _sortAscending = true;

  void _applyFilters() {
    setState(() {
      _filteredCustomers = _allCustomers.where((customer) {
        bool matchesSearch = customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            customer.phone.toString().contains(_searchQuery);
        
        return matchesSearch;
      }).toList();

      _sortItems();
    });
  }

  void _sortItems() {
    _filteredCustomers.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'phone':
          comparison = a.phone.compareTo(b.phone);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });
  }

  Future<void> _newCustomer() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewCustomerPage()));
    if (result != null && result == true) {
      setState(() {});
    }
  }

  void _deleteItem(int id) async {
    customerService.delete(id);
    setState(() {});
  }

  void _customerDetails(int id) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomerDetailsPage(customerId: id)));
    if (result != null && result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: CustomersPage.title,
      body: Column(
        children: [
          // Barra de búsqueda usando widget componentizado
          CustomSearchBar(
            hintText: 'Buscar clientes...',
            onChanged: (value) {
              _searchQuery = value;
              _applyFilters();
            },
          ),
          // Filtros y ordenamiento usando widget componentizado
          FilterSortRow(
            sortOptions: [
              DropdownMenuItem(value: 'name', child: Text('Nombre')),
              DropdownMenuItem(value: 'phone', child: Text('Teléfono')),
            ],
            sortBy: _sortBy,
            onSortChanged: (String? newValue) {
              if (newValue != null) {
                _sortBy = newValue;
                _applyFilters();
              }
            },
            sortAscending: _sortAscending,
            onSortDirectionChanged: () {
              _sortAscending = !_sortAscending;
              _applyFilters();
            },
          ),
          Divider(),
          // Lista de clientes
          Expanded(
            child: FutureBuilder<List<Customer>>(
              future: customerService.getAllCustomers(),
              builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar los clientes'));
                }
                else {
                  _allCustomers = snapshot.data!;
                  if (_filteredCustomers.isEmpty && _searchQuery.isEmpty) {
                    _filteredCustomers = _allCustomers;
                    _sortItems();
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                      return Future(() => null);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      itemCount: _filteredCustomers.length,
                      itemBuilder: (BuildContext context, int index) {
                        final customer = _filteredCustomers[index];
                        
                        return DismissibleListItem(
                          itemId: customer.id.toString(),
                          itemName: customer.name,
                          deleteTitle: 'Eliminación de cliente',
                          deleteMessage: '¿Confirmas la eliminación de "${customer.name}"?',
                          deleteSuccessMessage: 'Cliente "${customer.name}" eliminado',
                          onDelete: () => _deleteItem(customer.id!),
                          child: InfoCard(
                            title: customer.name,
                            onTap: () => _customerDetails(customer.id!),
                            fields: [
                              InfoCardField(
                                value: customer.phone.toString(),
                                icon: Icons.phone,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newCustomer,
        child: Icon(Icons.add),
      ),
    );
  }
}