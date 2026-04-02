import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/view_model/models/product_model.dart';

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
    return Center(child: Text('No Product contain searched characters!!'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var searchList = query.isEmpty
        ? products
        : products
              .where(
                (p) => p.productName!.toLowerCase().startsWith(
                  query.toLowerCase(),
                ),
              )
              .toList();

    return ListView.builder(
      itemCount: searchList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchList[index].productName ?? 'no product'),
        );
      },
    );
  }
}
