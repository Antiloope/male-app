import 'package:flutter/material.dart';
import 'package:male_naturapp/models/product_category.dart';
import 'package:male_naturapp/pages/products/categories/edit_category_page.dart';
import 'package:male_naturapp/pages/products/categories/new_category_page.dart';
import 'package:male_naturapp/services/product/product_service.dart';
import 'package:male_naturapp/services/product/product_service_provider.dart';
import 'package:male_naturapp/widgets/app_bar_frame.dart';
import 'package:male_naturapp/widgets/custom_search_bar.dart';
import 'package:male_naturapp/widgets/filter_sort_row.dart';
import 'package:male_naturapp/widgets/dismissible_list_item.dart';
import 'package:male_naturapp/widgets/info_card.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({super.key});

  static String title = "Categorías";

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  _CategoriesPageState() : productService = DefaultProductServiceProvider.getDefaultProductService();

  late final ProductService productService;
  List<ProductCategory> _allCategories = [];
  List<ProductCategory> _filteredCategories = [];
  String _searchQuery = '';
  String _sortBy = 'name'; // name
  bool _sortAscending = true;

  void _applyFilters() {
    setState(() {
      _filteredCategories = _allCategories.where((category) {
        bool matchesSearch = category.name.toLowerCase().contains(_searchQuery.toLowerCase());
        
        return matchesSearch;
      }).toList();

      _sortItems();
    });
  }

  void _sortItems() {
    _filteredCategories.sort((a, b) {
      int comparison = a.name.compareTo(b.name);
      return _sortAscending ? comparison : -comparison;
    });
  }

  Future<void> _newCategory() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewCategoryPage()));
    if (result != null && result == true) {
      setState(() {});
    }
  }

  void _deleteItem(int id) async {
    productService.deleteCategory(id);
    setState(() {});
  }

  void _editItem(ProductCategory category) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditCategoryPage(category)));
    if (result != null && result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarFrame(
      title: CategoriesPage.title,
      body: Column(
        children: [
          // Barra de búsqueda usando widget componentizado
          CustomSearchBar(
            hintText: 'Buscar categorías...',
            onChanged: (value) {
              _searchQuery = value;
              _applyFilters();
            },
          ),
          // Filtros y ordenamiento usando widget componentizado
          FilterSortRow(
            sortOptions: [
              DropdownMenuItem(value: 'name', child: Text('Nombre')),
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
          // Lista de categorías
          Expanded(
            child: FutureBuilder<List<ProductCategory>>(
              future: productService.getAllCategories(),
              builder: (BuildContext context, AsyncSnapshot<List<ProductCategory>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar las categorías'));
                }
                else {
                  _allCategories = snapshot.data!;
                  if (_filteredCategories.isEmpty && _searchQuery.isEmpty) {
                    _filteredCategories = _allCategories;
                    _sortItems();
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                      return Future(() => null);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      itemCount: _filteredCategories.length,
                      itemBuilder: (BuildContext context, int index) {
                        final category = _filteredCategories[index];
                        
                        return DismissibleListItem(
                          itemId: category.id.toString(),
                          itemName: category.name,
                          deleteTitle: 'Eliminación de categoría',
                          deleteMessage: '¿Confirmas la eliminación de "${category.name}"?',
                          deleteSuccessMessage: 'Categoría "${category.name}" eliminada',
                          onDelete: () => _deleteItem(category.id!),
                          child: InfoCard(
                            title: category.name,
                            fields: [
                              InfoCardField(
                                value: 'Categoría de productos',
                                icon: Icons.category,
                              ),
                            ],
                            trailing: IconButton(
                              onPressed: () => _editItem(category),
                              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _newCategory,
        child: Icon(Icons.add),
      ),
    );
  }
}