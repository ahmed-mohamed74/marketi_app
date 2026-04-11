import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/product_card_widget.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/search_section_widget.dart';

class CategoryPage extends StatefulWidget {
  final String? categoryName;
  const CategoryPage({super.key, required this.categoryName});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getProductsByCategory(
      widget.categoryName ?? 'smartphones',
    );
  }

  @override
  Widget build(BuildContext context) {
    // List<ProductModel> products = DummyData.products;

    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text(
          widget.categoryName ?? 'Electronics',
          style: AppTextStyles.appBarTitle1,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.shopping_cart_outlined, size: 30),
          ),
        ],
      ),
      body: BlocListener<AddProductCubit, AddProductState>(
        listener: (context, state) {
          if (state is AddCartProductSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.productsByCategoryStatus == RequestStatus.loading) {
              return const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state.productsByCategoryStatus == RequestStatus.error) {
              return SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    state.productsByCategoryError ?? 'Something went wrong',
                  ),
                ),
              );
            } else if (state.productsByCategory.isEmpty) {
              return const SizedBox(
                height: 60,
                child: Center(child: Text('No items found')),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SearchSectionWidget(products: state.productsByCategory),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 590,
                    child: ListView.builder(
                      itemCount: state.productsByCategory.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.push(
                                  AppRoutes.productPage,
                                  extra: state.productsByCategory[index],
                                );
                              },
                              child: ProductCard(
                                image:
                                    state
                                        .productsByCategory[index]
                                        .images
                                        ?.first ??
                                    '',
                                price:
                                    state.productsByCategory[index].price
                                        ?.toString() ??
                                    '',
                                rate:
                                    state.productsByCategory[index].rating
                                        ?.toString() ??
                                    '',
                                name:
                                    state.productsByCategory[index].title ?? '',
                                id: state.productsByCategory[index].id
                                    .toString(),
                              ),
                            ),
                            Divider(
                              color: AppColors.greyScaleColor.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
