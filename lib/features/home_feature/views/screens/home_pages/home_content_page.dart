import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/views/bloc/cubit/home_cubit.dart';
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
                      onPressed: () {},
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
                    SectionHeaderWidget(title: 'Category', onPressed: () {}),
                    state.categories.isNotEmpty
                        ? CategoryBrandSectionWidget(
                            isBrand: false,
                            categories: state.categories,
                            brands: state.brands,
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
                      onPressed: () {},
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
                    SectionHeaderWidget(title: 'Brands', onPressed: () {}),
                    state.categories.isNotEmpty
                        ? CategoryBrandSectionWidget(
                            isBrand: true,
                            categories: state.categories,
                            brands: state.brands,
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
                    SectionHeaderWidget(title: 'Buy Again', onPressed: () {}),
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
