import 'package:flutter/material.dart';
import 'package:male_naturapp/models/product.dart';
import 'package:male_naturapp/models/product_category.dart';
import 'package:male_naturapp/pages/products/new_product_page.dart';
import 'package:male_naturapp/pages/products/product_details_page.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';
import 'package:male_naturapp/widgets/custom_search_bar.dart';
import 'package:male_naturapp/widgets/filter_sort_row.dart';
import 'package:male_naturapp/widgets/dismissible_list_item.dart';
import 'package:male_naturapp/widgets/info_card.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({super.key});

  static String title = "Productos";

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  _ProductsPageState() : productService = DefaultProductServiceProvider.getDefaultProductService();

  late final ProductService productService;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<ProductCategory> _categories = [];
  String _searchQuery = '';
  String _selectedCategory = 'Todos';
  String _sortBy = 'name'; // name, category
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
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
        
        bool matchesCategory = _selectedCategory == 'Todos' || 
            _getCategoryName(product.category) == _selectedCategory;
        
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
          break;
        case 'category':
          String categoryA = _getCategoryName(a.category);
          String categoryB = _getCategoryName(b.category);
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

  List<String> _getCategoryNames() {
    List<String> categoryNames = _categories.map((cat) => cat.name).toList();
    categoryNames.sort();
    return ['Todos', ...categoryNames];
  }

  Future<void> _newProduct() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewProductPage()));
    if (result != null && result == true) {
      setState(() {});
    }
  }

  void _deleteItem(int id) async {
    productService.delete(id);
    setState(() {});
  }

  void _productDetails(int id) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: id)));
    if (result != null && result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: ProductsPage.title,
      body: Column(
        children: [
          // Barra de búsqueda usando widget componentizado
          CustomSearchBar(
            hintText: 'Buscar productos...',
            onChanged: (value) {
              _searchQuery = value;
              _applyFilters();
            },
          ),
          // Filtros y ordenamiento usando widget componentizado
          FilterSortRow(
            categories: _getCategoryNames(),
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
          // Lista de productos
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
                  
                  return RefreshIndicator(
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
                        
                        return DismissibleListItem(
                          itemId: product.id.toString(),
                          itemName: product.name,
                          deleteTitle: 'Eliminación de producto',
                          deleteMessage: '¿Confirmas la eliminación de "${product.name}"?',
                          deleteSuccessMessage: 'Producto "${product.name}" eliminado',
                          onDelete: () => _deleteItem(product.id!),
                          child: InfoCard(
                            title: product.name,
                            subtitle: product.description,
                            onTap: () => _productDetails(product.id!),
                            fields: [
                              InfoCardField(
                                value: categoryName,
                                icon: Icons.category,
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
        onPressed: _newProduct,
        child: Icon(Icons.add),
      ),
    );
  }
}