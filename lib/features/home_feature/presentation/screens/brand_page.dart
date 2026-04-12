import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/product_card_with_details_widget.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/search_section_widget.dart';

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
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text(
          widget.brandName ?? 'Essence',
          style: AppTextStyles.appBarTitle1,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.shopping_cart_outlined, size: 30),
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
                  SnackBar(content: Text("Removed from favorites")),
                );
              } else if (state is DeleteFavouriteProductFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Failed to remove")));
              }
            },
          ),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, homeState) {
            if (homeState.productsByBrandStatus == RequestStatus.loading) {
              return const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (homeState.productsByBrandStatus == RequestStatus.error) {
              return SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    homeState.productsByBrandError ?? 'Something went wrong',
                  ),
                ),
              );
            } else if (homeState.productsByBrand.isNotEmpty) {
              return BlocBuilder<GetFavouriteCubit, GetFavouriteState>(
              builder: (context, favState) {
                List<int> favIds = [];
                if (favState is GetFavouritesProductsSuccess) {
                  favIds = favState.favouriteProducts
                      .map((p) => p.id!)
                      .toList();
                }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SearchSectionWidget(products: homeState.productsByBrand),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: homeState.productsByBrand.length,
                            itemBuilder: (context, index) {
                              final product = homeState.productsByBrand[index];
                              final bool isProductInFav = favIds.contains(
                              product.id,
                            );
                              return Column(
                                children: [
                                  GestureDetector(
                                  onTap: () => context.push(
                                    AppRoutes.productPage,
                                    extra: product,
                                  ),
                                  child: ProductCardWithDetails(
                                    id: product.id.toString(),
                                    name: product.title,
                                    image: product.images?.first ?? '',
                                    price: product.price?.toString() ?? '',
                                    rate: product.rating?.toString() ?? '',
                                    isFavourite:
                                        isProductInFav, quantity: 1, onIncrement: () {  }, onDecrement: () {  }, onDelete: () {  },
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
              );
            }
            return const SizedBox(
              height: 60,
              child: Center(child: Text('No items found')),
            );
          },
        ),
      ),
    );
  }
}
