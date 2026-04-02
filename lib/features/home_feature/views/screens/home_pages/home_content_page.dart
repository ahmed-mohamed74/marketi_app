import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/constants/app_routes.dart';
import 'package:marketi_app/features/home_feature/view_model/models/product_model.dart';
import 'package:marketi_app/features/home_feature/views/cubit/home_cubit.dart';
import 'package:marketi_app/features/home_feature/views/widgets/carousel_slider_widget.dart';
import 'package:marketi_app/features/home_feature/views/widgets/category_section_widget.dart';
import 'package:marketi_app/features/home_feature/views/widgets/popular_product_section_widget.dart';
import 'package:marketi_app/features/home_feature/views/widgets/search_section_widget.dart';
import 'package:marketi_app/features/home_feature/views/widgets/section_header_widget.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    final cubit = context.read<HomeCubit>();
    cubit.getPopularProducts();
    cubit.getBestProducts();
    cubit.getBuyAgainProducts();
    cubit.getCategories();
    cubit.getBrands();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return SearchSectionWidget(products: state.popularProducts);
              },
            ),
            const SizedBox(height: 14),

            CarouselSliderWidget(),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SectionHeaderWidget(
                      title: 'Popular Product',
                      onPressed: () {
                        context.push(
                          AppRoutes.allProductsPage,
                          extra: {
                            'title': 'Popular Product',
                            'items': state.popularProducts,
                          },
                        );
                      },
                    ),
                    state.popularProducts.isNotEmpty
                        ? ProductsSectionWidget(
                            popularProducts: state.popularProducts,
                          )
                        : const SizedBox(
                            height: 60,
                            child: Center(child: Text('no products')),
                          ),
                  ],
                );
              },
            ),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SectionHeaderWidget(
                      title: 'Category',
                      onPressed: () {
                        context.push(
                          AppRoutes.allCategoryBrandsPage,
                          extra: {
                            'title': 'Category',
                            'items': state.categories,
                          },
                        );
                      },
                    ),
                    state.categories.isNotEmpty
                        ? CategoryBrandSectionWidget(
                            isBrand: false,
                            items: state.categories,
                          )
                        : const SizedBox(
                            height: 60,
                            child: Center(child: Text('no products')),
                          ),
                  ],
                );
              },
            ),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SectionHeaderWidget(
                      title: 'Best for You',
                      onPressed: () {
                        context.push(
                          AppRoutes.allProductsPage,
                          extra: {
                            'title': 'Best for You',
                            'items': state.bestProducts,
                          },
                        );
                      },
                    ),
                    state.bestProducts.isNotEmpty
                        ? ProductsSectionWidget(
                            withAddButton: true,
                            popularProducts: state.bestProducts,
                          )
                        : const SizedBox(
                            height: 60,
                            child: Center(child: Text('no products')),
                          ),
                  ],
                );
              },
            ),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SectionHeaderWidget(title: 'Brands', onPressed: () {
                      context.push(
                          AppRoutes.allCategoryBrandsPage,
                          extra: {
                            'title': 'Brands',
                            'items': state.brands,
                          },
                        );
                    }),
                    state.brands.isNotEmpty
                        ? CategoryBrandSectionWidget(
                            isBrand: true,
                            items: state.brands,
                          )
                        : const SizedBox(
                            height: 60,
                            child: Center(child: Text('no products')),
                          ),
                  ],
                );
              },
            ),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SectionHeaderWidget(
                      title: 'Buy Again',
                      onPressed: () {
                        context.push(
                          AppRoutes.allProductsPage,
                          extra: {
                            'title': 'Buy Again',
                            'items': state.buyAgainProducts,
                          },
                        );
                      },
                    ),
                    state.bestProducts.isNotEmpty
                        ? ProductsSectionWidget(
                            withAddButton: true,
                            popularProducts: state.buyAgainProducts,
                          )
                        : const SizedBox(
                            height: 60,
                            child: Center(child: Text('no products')),
                          ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
