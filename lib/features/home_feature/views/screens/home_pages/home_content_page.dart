import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/constants/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/views/cubit/home_cubit.dart';
import 'package:marketi_app/features/home_feature/views/widgets/carousel_slider_widget.dart';
import 'package:marketi_app/features/home_feature/views/widgets/category_section_widget.dart';
import 'package:marketi_app/features/home_feature/views/widgets/popular_product_section_widget.dart';
import 'package:marketi_app/features/home_feature/views/widgets/search_section_widget.dart';
import 'package:marketi_app/features/home_feature/views/widgets/section_header_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeCubit>();
    cubit.getPopularProducts();
    cubit.getBestProducts();
    cubit.getBuyAgainProducts();
    cubit.getCategories();
    cubit.getBrands();
  }

  Widget _buildSection<T>({
    required String title,
    required List<T> items,
    required RequestStatus status,
    String? error,
    required VoidCallback onSeeAll,
    required Widget Function(List<T> items) builder,
  }) {
    if (status == RequestStatus.loading) {
      return const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (status == RequestStatus.error) {
      return SizedBox(
        height: 60,
        child: Center(child: Text(error ?? 'Something went wrong')),
      );
    } else if (items.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Center(child: Text('No items found')),
      );
    } else {
      return builder(items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CircleAvatar(
            backgroundColor: AppColors.lightBlueColor,
            foregroundColor: AppColors.navyColor,
            child: const Icon(Icons.person_2_outlined, size: 30),
          ),
        ),
        title: Text('Hi User !', style: AppTextStyles.appBarTitle1),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(14),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SearchSectionWidget(products: state.bestProducts),
                  const SizedBox(height: 14),
                  const CarouselSliderWidget(),
                  const SizedBox(height: 20),

                  // Popular Products
                  Column(
                    children: [
                      SectionHeaderWidget(
                        title: 'Popular Product',
                        onPressed: () {
                          context.push(
                            AppRoutes.allProductsPage,
                            extra: 'Popular Product',
                          );
                        },
                      ),
                      _buildSection(
                        title: 'Popular Product',
                        items: state.popularProducts,
                        status: state.popularStatus,
                        error: state.popularError,
                        onSeeAll: () {},
                        builder: (items) =>
                            ProductsSectionWidget(popularProducts: items),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Categories
                  Column(
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
                      _buildSection(
                        title: 'Categories',
                        items: state.categories,
                        status: state.categoriesStatus,
                        error: state.categoriesError,
                        onSeeAll: () {},
                        builder: (items) => CategoryBrandSectionWidget(
                          isBrand: false,
                          categoryItems: state.categories,
                          brandItems: state.brands,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Best Products
                  Column(
                    children: [
                      SectionHeaderWidget(
                        title: 'Best for You',
                        onPressed: () {
                          context.push(
                            AppRoutes.allProductsPage,
                            extra: 'Best for You',
                          );
                        },
                      ),
                      _buildSection(
                        title: 'Best Products',
                        items: state.bestProducts,
                        status: state.bestStatus,
                        error: state.bestError,
                        onSeeAll: () {},
                        builder: (items) => ProductsSectionWidget(
                          popularProducts: items,
                          withAddButton: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Brands
                  Column(
                    children: [
                      SectionHeaderWidget(
                        title: 'Brands',
                        onPressed: () {
                          context.push(
                            AppRoutes.allCategoryBrandsPage,
                            extra: {'title': 'Brands', 'items': state.brands},
                          );
                        },
                      ),
                      _buildSection(
                        title: 'Brands',
                        items: state.brands,
                        status: state.brandsStatus,
                        error: state.brandsError,
                        onSeeAll: () {},
                        builder: (items) => CategoryBrandSectionWidget(
                          isBrand: true,
                          categoryItems: state.categories,
                          brandItems: state.brands,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Buy Again
                  Column(
                    children: [
                      SectionHeaderWidget(
                        title: 'Buy Again',
                        onPressed: () {
                          context.push(
                            AppRoutes.allProductsPage,
                            extra: 'Buy Again',
                          );
                        },
                      ),
                      _buildSection(
                        title: 'Buy Again',
                        items: state.buyAgainProducts,
                        status: state.buyAgainStatus,
                        error: state.buyAgainError,
                        onSeeAll: () {},
                        builder: (items) => ProductsSectionWidget(
                          popularProducts: items,
                          withAddButton: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
