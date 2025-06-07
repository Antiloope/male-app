import 'package:flutter/material.dart';
import 'package:male_naturapp/models/product.dart';
import 'package:male_naturapp/models/product_category.dart';
import 'package:male_naturapp/models/supply_entry_item.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';
import 'package:male_naturapp/widgets/custom_search_bar.dart';
import 'package:male_naturapp/widgets/filter_sort_row.dart';
import 'package:male_naturapp/widgets/info_card.dart';

class ProductSelectionPage extends StatefulWidget {
  const ProductSelectionPage({super.key});

  static const String title = "Seleccionar Producto";

  @override
  _ProductSelectionPageState createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  late final ProductService productService;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<ProductCategory> _categories = [];
  String _searchQuery = '';
  String _selectedCategory = 'Todos';
  String _sortBy = 'name';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    productService = DefaultProductServiceProvider.getDefaultProductService();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      _categories = await productService.getAllCategories();
    } catch (e) {
      _categories = [];
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        bool matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.description.toLowerCase().contains(_searchQuery.toLowerCase());
        
        String categoryName = _getCategoryName(product.category);
        bool matchesCategory = _selectedCategory == 'Todos' || categoryName == _selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();

      _sortItems();
    });
  }

  void _sortItems() {
    _filteredProducts.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
        case 'category':
          String categoryA = _getCategoryName(a.category);
          String categoryB = _getCategoryName(b.category);
          comparison = categoryA.compareTo(categoryB);
      }
      return _sortAscending ? comparison : -comparison;
    });
  }

  String _getCategoryName(int categoryId) {
    try {
      return _categories.firstWhere((cat) => cat.id == categoryId).name;
    } catch (e) {
      return 'Sin categoría';
    }
  }

  List<String> _getCategories() {
    List<String> categoryNames = _categories.map((cat) => cat.name).toList();
    categoryNames.sort();
    return ['Todos', ...categoryNames];
  }

  void _selectProduct(Product product) {
    _showQuantityDialog(product);
  }

  void _showQuantityDialog(Product product) {
    final TextEditingController quantityController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cantidad a Ingresar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Producto: ${product.name}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  hintText: 'Ej: 10',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final quantityText = quantityController.text.trim();
                if (quantityText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor ingresa una cantidad válida')),
                  );
                  return;
                }

                final quantity = int.tryParse(quantityText);
                if (quantity == null || quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('La cantidad debe ser un número mayor a 0')),
                  );
                  return;
                }

                final supplyItem = SupplyEntryItem(
                  product: product,
                  quantity: quantity,
                );

                Navigator.of(context).pop();
                Navigator.of(context).pop(supplyItem);
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: ProductSelectionPage.title,
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Buscar productos...',
            onChanged: (value) {
              _searchQuery = value;
              _applyFilters();
            },
          ),
          FilterSortRow(
            categories: _getCategories(),
            selectedCategory: _selectedCategory,
            onCategoryChanged: (String? newValue) {
              if (newValue != null) {
                _selectedCategory = newValue;
                _applyFilters();
              }
            },
            sortOptions: [
              DropdownMenuItem(value: 'name', child: Text('Nombre')),
              DropdownMenuItem(value: 'category', child: Text('Categoría')),
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
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productService.getAllProducts(),
              builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar los productos'));
                }
                else {
                  _allProducts = snapshot.data!;
                  if (_filteredProducts.isEmpty && _searchQuery.isEmpty && _selectedCategory == 'Todos') {
                    _filteredProducts = _allProducts;
                    _sortItems();
                  }
                  
                  return _filteredProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No se encontraron productos',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            setState(() {});
                            return Future(() => null);
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                            itemCount: _filteredProducts.length,
                            itemBuilder: (BuildContext context, int index) {
                              final product = _filteredProducts[index];
                              final categoryName = _getCategoryName(product.category);
                              
                              return InkWell(
                                onTap: () => _selectProduct(product),
                                child: InfoCard(
                                  title: product.name,
                                  subtitle: product.description,
                                  fields: [
                                    InfoCardField(
                                      value: categoryName,
                                      icon: Icons.category,
                                    ),
                                  ],
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Theme.of(context).colorScheme.outline,
                                      ),
                                    ],
                                  ),
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
    );
  }
} 