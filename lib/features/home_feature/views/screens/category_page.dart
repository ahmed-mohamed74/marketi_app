import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/dummy_data.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/view_model/models/product_model.dart';
import 'package:marketi_app/features/home_feature/views/widgets/product_card_widget.dart';
import 'package:marketi_app/features/home_feature/views/widgets/search_section_widget.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ProductModel> products = DummyData.products;
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text('Electronics', style: AppTextStyles.appBarTitle1),
        actions: const [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.shopping_cart_outlined, size: 30),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchSectionWidget(products: products),
            SizedBox(height: 10),
            SizedBox(
              height: 590,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ProductCard(
                        image: products[index].images?.first ?? '',
                        price: products[index].price?.toString() ?? '',
                        rate: products[index].rating?.toString() ?? '',
                        name: products[index].title ?? '',
                      ),
                      Divider(
                        color: AppColors.greyScaleColor.withValues(alpha: 0.2),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

