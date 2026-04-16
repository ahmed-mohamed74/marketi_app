import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';
import 'package:marketi_app/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:marketi_app/features/home/presentation/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:marketi_app/features/home/presentation/widgets/product_card_with_details_widget.dart';
import 'package:marketi_app/features/home/presentation/widgets/search_section_widget.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Add this
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';

class BrandPage extends StatefulWidget {
  final String? brandName;
  const BrandPage({super.key, required this.brandName});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getProductsByBrand(widget.brandName ?? 'Essence');
    context.read<GetFavouriteCubit>().getFavouriteProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () {
          context.pop();
        }),
        leadingWidth: 64,
        title: Text(
          widget.brandName ?? 'Essence',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined, size: 30),
              onPressed: () {
                setState(() {
                  context.read<NavigationCubit>().updateIndex(1);
                  context.go(AppRoutes.home);
                });
              },
            ),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AddProductCubit, AddProductState>(
            listener: (context, state) {
              if (state is AddCartProductSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<AddFavouriteCubit, AddFavouriteState>(
            listener: (context, state) {
              if (state is AddFavouriteProductSuccess) {
                context.read<GetFavouriteCubit>().getFavouriteProducts();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<DeleteFavouriteCubit, DeleteFavouriteState>(
            listener: (context, state) {
              if (state is DeleteFavouriteProductSuccess) {
                context.read<GetFavouriteCubit>().getFavouriteProducts();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Removed from favorites")),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, homeState) {
            final bool isLoading =
                homeState.productsByBrandStatus == RequestStatus.loading;

            // Handle Error State
            if (homeState.productsByBrandStatus == RequestStatus.error &&
                homeState.productsByBrand.isEmpty) {
              return Center(
                child: Text(
                  homeState.productsByBrandError ?? 'Something went wrong',
                ),
              );
            }

            final List<ProductModel> products = isLoading
                ? List.generate(
                    5,
                    (index) => ProductModel(
                      id: index,
                      title: 'Loading Brand Product',
                      price: 0.0,
                      rating: 0.0,
                      images: [''],
                    ),
                  )
                : homeState.productsByBrand;

            // Handle Empty State
            if (!isLoading && products.isEmpty) {
              return const Center(child: Text('No items found'));
            }

            return BlocBuilder<GetFavouriteCubit, GetFavouriteState>(
              builder: (context, favState) {
                List<int> favIds = [];
                if (favState is GetFavouritesProductsSuccess) {
                  favIds = favState.favouriteProducts
                      .map((p) => p.id!)
                      .toList();
                }

                return Skeletonizer(
                  enabled: isLoading,
                  ignoreContainers: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SearchSectionWidget(products: products),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final bool isProductInFav = favIds.contains(
                                product.id,
                              );

                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: isLoading
                                        ? null
                                        : () => context.push(
                                            AppRoutes.productPage,
                                            extra: product,
                                          ),
                                    child: ProductCardWithDetails(
                                      id: product.id.toString(),
                                      name: product.title ?? '',
                                      image:
                                          (product.images?.isNotEmpty ?? false)
                                          ? product.images!.first
                                          : '',
                                      price: product.price?.toString() ?? '0.0',
                                      rate: product.rating?.toString() ?? '0.0',
                                      isFavourite: isProductInFav,
                                      quantity: 1,
                                      onIncrement: () {},
                                      onDecrement: () {},
                                      onDelete: () {},
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
