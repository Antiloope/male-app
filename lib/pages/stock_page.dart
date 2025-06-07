import 'package:flutter/material.dart';
import 'package:male_naturapp/models/stock_item.dart';
import 'package:male_naturapp/models/product_category.dart';
import 'package:male_naturapp/services/stock/stock_service.dart';
import 'package:male_naturapp/services/stock/stock_service_provider.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';
import 'package:male_naturapp/pages/stock/stock_entry_type_selection_page.dart';
import 'package:male_naturapp/pages/stock/stock_exit_page.dart';
import 'package:male_naturapp/widgets/custom_search_bar.dart';
import 'package:male_naturapp/widgets/filter_sort_row.dart';
import 'package:male_naturapp/widgets/info_card.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  static Icon icon = Icon(Icons.archive);
  static String title = "Stock";

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  _StockPageState() : 
    stockService = DefaultStockServiceProvider.getDefaultStockService(),
    productService = DefaultProductServiceProvider.getDefaultProductService();

  late final StockService stockService;
  late final ProductService productService;
  List<StockItem> _allStockItems = [];
  List<StockItem> _filteredStockItems = [];
  List<ProductCategory> _categories = [];
  String _searchQuery = '';
  String _selectedCategory = 'Todos';
  String _sortBy = 'name';
  bool _sortAscending = true;
  late Future<List<StockItem>> _stockItemsFuture;

  @override
  void initState() {
    super.initState();
    _stockItemsFuture = stockService.getAllStockItems();
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
      _filteredStockItems = _allStockItems.where((item) {
        bool matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.description.toLowerCase().contains(_searchQuery.toLowerCase());
        
        String categoryName = _getCategoryName(item.categoryId);
        bool matchesCategory = _selectedCategory == 'Todos' || categoryName == _selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();

      _sortItems();
    });
  }

  void _sortItems() {
    _filteredStockItems.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'quantity':
          comparison = a.quantity.compareTo(b.quantity);
          break;
        case 'price':
          comparison = a.price.compareTo(b.price);
          break;
        case 'category':
          String categoryA = _getCategoryName(a.categoryId);
          String categoryB = _getCategoryName(b.categoryId);
          comparison = categoryA.compareTo(categoryB);
          break;
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

  void _refreshStockItems() {
    setState(() {
      _stockItemsFuture = stockService.getAllStockItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              DropdownMenuItem(value: 'quantity', child: Text('Cantidad')),
              DropdownMenuItem(value: 'price', child: Text('Precio')),
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
            child: FutureBuilder<List<StockItem>>(
              future: _stockItemsFuture,
              builder: (BuildContext context, AsyncSnapshot<List<StockItem>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar los datos de stock'));
                }
                else {
                  _allStockItems = snapshot.data!;
                  if (_filteredStockItems.isEmpty && _searchQuery.isEmpty && _selectedCategory == 'Todos') {
                    _filteredStockItems = _allStockItems;
                    _sortItems();
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      _refreshStockItems();
                      return Future(() => null);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      itemCount: _filteredStockItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = _filteredStockItems[index];
                        final categoryName = _getCategoryName(item.categoryId);
                        
                        return InfoCard(
                          title: item.name,
                          subtitle: item.description,
                          fields: [
                            InfoCardField(
                              value: categoryName,
                              icon: Icons.category,
                            ),
                          ],
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${item.quantity}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => StockEntryTypeSelectionPage())
              );
              if (result != null && result == true) {
                _refreshStockItems();
              }
            },
            label: Text('Ingreso'),
            icon: Icon(Icons.add),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            heroTag: "ingreso",
          ),
          SizedBox(width: 16),
          FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => StockExitPage())
              );
              if (result != null && result == true) {
                _refreshStockItems();
              }
            },
            label: Text('Egreso'),
            icon: Icon(Icons.remove),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            heroTag: "egreso",
          ),
        ],
      ),
    );
  }
}