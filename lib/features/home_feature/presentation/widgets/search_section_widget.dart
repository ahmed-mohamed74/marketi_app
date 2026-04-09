import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/data/models/product_model.dart';

class SearchSectionWidget extends StatelessWidget {
  final List<ProductModel> products;
  const SearchSectionWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showSearch(
          context: context,
          delegate: DataSearch(products: products),
        );
      },
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.lightBlueColor),
      ),
      leading: Icon(Icons.search),
      trailing: Icon(
        Icons.filter_list,
        size: 25,
        color: AppColors.primaryColor,
      ),
      title: Text('What are you looking for ?', style: AppTextStyles.bodyText),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<ProductModel> products;
  static List<String> searchHistory = [];

  DataSearch({
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction,
    super.autocorrect,
    super.enableSuggestions,
    required this.products,
  });
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, query);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where(
          (p) => (p.title ?? '').toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    if (results.isEmpty) {
      return Center(child: Text('No Product found'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(results[index].title ?? ''));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Popular = أول 5 منتجات مثلا
    final popularProducts = products.take(5).toList();

    var searchList = query.isEmpty
        ? []
        : products
              .where(
                (p) =>
                    (p.title ?? '').toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (query.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Popular Search', style: AppTextStyles.heading2),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 20,
                children: popularProducts.map((p) {
                  return ActionChip(
                    color: WidgetStatePropertyAll(
                      AppColors.lightBlueColor.withValues(alpha: 0.5),
                    ),
                    label: Text(
                      p.title ?? '',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: BorderSide(
                        width: 0,
                        color: AppColors.lightBlueColor.withValues(alpha: 0.1),
                      ),
                    ),
                    onPressed: () {
                      query = p.title ?? '';
                      showResults(context);
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),
          ],

          if (query.isEmpty && searchHistory.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Search History', style: AppTextStyles.heading2),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: searchHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchHistory[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      searchHistory.removeAt(index);
                      showSuggestions(context);
                    },
                  ),
                  onTap: () {
                    query = searchHistory[index];
                    showResults(context);
                  },
                );
              },
            ),
          ],

          /// 🔍 Search Results
          if (query.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                final product = searchList[index];

                return ListTile(
                  title: Text(product.title ?? ''),
                  onTap: () {
                    // searchHistory.remove(product.title);
                    searchHistory.insert(0, product.title ?? '');

                    query = product.title ?? '';
                    showResults(context);
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
