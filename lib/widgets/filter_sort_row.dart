import 'package:flutter/material.dart';

class FilterSortRow extends StatelessWidget {
  final List<String>? categories;
  final String? selectedCategory;
  final ValueChanged<String?>? onCategoryChanged;
  final List<DropdownMenuItem<String>> sortOptions;
  final String sortBy;
  final ValueChanged<String?> onSortChanged;
  final bool sortAscending;
  final VoidCallback onSortDirectionChanged;

  const FilterSortRow({
    super.key,
    this.categories,
    this.selectedCategory,
    this.onCategoryChanged,
    required this.sortOptions,
    required this.sortBy,
    required this.onSortChanged,
    required this.sortAscending,
    required this.onSortDirectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Filtro por categoría (opcional)
          if (categories != null && onCategoryChanged != null) ...[
            Expanded(
              flex: 2,
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                items: categories!.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: onCategoryChanged,
              ),
            ),
            SizedBox(width: 16),
          ],
          // Ordenamiento
          Expanded(
            flex: categories != null ? 2 : 3,
            child: DropdownButton<String>(
              value: sortBy,
              isExpanded: true,
              items: sortOptions,
              onChanged: onSortChanged,
            ),
          ),
          IconButton(
            icon: Icon(sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: onSortDirectionChanged,
          ),
        ],
      ),
    );
  }
} 