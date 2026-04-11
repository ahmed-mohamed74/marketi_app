import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/data/models/product_model.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/home_cubit/home_cubit.dart';

class SearchSectionWidget extends StatelessWidget {
  final List<ProductModel> products;
  const SearchSectionWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final homeCubit = context.read<HomeCubit>();
        homeCubit.getCategoryNames();

        showSearch(
          context: context,
          delegate: DataSearch(homeCubit: homeCubit, initialProducts: products),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.lightBlueColor),
      ),
      leading: const Icon(Icons.search),
      trailing: const Icon(
        Icons.filter_list,
        size: 25,
        color: AppColors.primaryColor,
      ),
      title: Text('What are you looking for?', style: AppTextStyles.bodyText),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final HomeCubit homeCubit;
  final List<ProductModel> initialProducts;
  static List<String> searchHistory = [];

  String selectedCategory = 'All';
  String priceSort = 'up';

  DataSearch({required this.homeCubit, required this.initialProducts});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.tune, color: AppColors.primaryColor),
        onPressed: () => _showFilterBottomSheet(context),
      ),
      IconButton(
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<HomeCubit, HomeState>(
          bloc: homeCubit,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Categories", style: AppTextStyles.heading2),
                  const SizedBox(height: 10),
                  if (state.categoryNamesStatus == RequestStatus.loading)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      height: MediaQuery.heightOf(context) * 0.35,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          children:
                              [
                                'All',
                                ...state.categoryNames.map((e) => e.name ?? ''),
                              ].map((cat) {
                                return ChoiceChip(
                                  label: Text(cat),
                                  selected: selectedCategory == cat,
                                  onSelected: (selected) {
                                    selectedCategory = cat;
                                    // TRIGGER: Refresh the search results with the new category
                                    showResults(context);
                                    Navigator.pop(context);
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Every time showResults() is called, this API is triggered with current filters
    homeCubit.getFilteredProducts(
      search: query,
      category: selectedCategory,
      priceSort: priceSort,
    );

    return BlocBuilder<HomeCubit, HomeState>(
      bloc: homeCubit,
      builder: (context, state) {
        if (state.searchStatus == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.searchResults.isEmpty) {
          return const Center(child: Text("No products match your filters"));
        }
        return _buildProductList(state.searchResults);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // LOCAL FILTERING for instant typing suggestions
    final suggestionList = initialProducts.where((p) {
      final matchesQuery = (p.title ?? '').toLowerCase().contains(
        query.toLowerCase(),
      );
      final matchesCategory =
          selectedCategory == 'All' || p.category == selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (query.isEmpty) ...[
                _sectionHeader('Popular Search'),
                _buildPopularChips(context),
                if (searchHistory.isNotEmpty) ...[
                  _sectionHeader('Search History'),
                  ...searchHistory.asMap().entries.map((entry) {
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(entry.value),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            setState(() => searchHistory.removeAt(entry.key)),
                      ),
                      onTap: () {
                        query = entry.value;
                        showResults(context);
                      },
                    );
                  }),
                ],
              ],
              if (query.isNotEmpty) _buildProductList(suggestionList),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductList(List<ProductModel> list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final product = list[index];
        return ListTile(
          leading: const Icon(Icons.search, size: 20),
          title: Text(product.title ?? ''),
          subtitle: Text(
            product.category ?? '',
            style: const TextStyle(fontSize: 12),
          ),
          onTap: () {
            if (!searchHistory.contains(product.title)) {
              searchHistory.insert(0, product.title ?? '');
            }
            context.push(AppRoutes.productPage, extra: product);
          },
        );
      },
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(title, style: AppTextStyles.heading2),
    );
  }

  Widget _buildPopularChips(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 10,
        children: initialProducts
            .take(4)
            .map(
              (p) => ActionChip(
                label: Text(p.title ?? ''),
                onPressed: () {
                  query = p.title ?? '';
                  showResults(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
