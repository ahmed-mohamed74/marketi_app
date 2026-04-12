import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/common/widgets/primary_button_widget.dart';
import 'package:marketi_app/core/constants/app_sizes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/delete_product_cubit/delete_product_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/get_product_cubit/get_products_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/product_card_with_details_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetProductsCubit>().getCartProducts();
    context.read<GetFavouriteCubit>().getFavouriteProducts();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = AppSizes(context: context).screenHeight;
    return Scaffold(
      appBar: AppBar(
        // leading: BackButtonWidget(onPressed: () => context.pop()),
        // leadingWidth: 64,
        title: Text('Cart', style: AppTextStyles.appBarTitle1),
        actions: const [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: CircleAvatar(
              backgroundColor: AppColors.lightBlueColor,
              foregroundColor: AppColors.navyColor,
              child: Icon(Icons.person_2_outlined, size: 30),
            ),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeleteProductCubit, DeleteProductState>(
            listener: (context, state) {
              if (state is DeleteCartProductSuccess) {
                context.read<GetProductsCubit>().getCartProducts();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
              if (state is DeleteCartProductFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
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
        child: BlocBuilder<GetProductsCubit, GetProductsState>(
          builder: (context, state) {
            print("Cart UI Rebuilt with state: $state");
            if (state is GetCartProductsLoading) {
              return const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is GetCartProductsSuccess) {
              if (state.cartProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 100,
                        color: AppColors.greyScaleColor,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your cart is empty!',
                        style: AppTextStyles.heading2,
                      ),
                    ],
                  ),
                );
              }
              return BlocBuilder<GetFavouriteCubit, GetFavouriteState>(
                builder: (context, favState) {
                  List<int> favIds = [];
                  if (favState is GetFavouritesProductsSuccess) {
                    favIds = favState.favouriteProducts
                        .map((p) => p.id!)
                        .toList();
                  }
                  return SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Products on Cart',
                            style: AppTextStyles.heading1,
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: SizedBox(
                                height: screenHeight * 0.617,
                                child: ListView.builder(
                                  itemCount: state.cartProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = state.cartProducts[index];
                                    final bool isProductInFav = favIds.contains(
                                      product.id,
                                    );
                                    return Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            border: Border.all(
                                              color: AppColors.lightBlueColor
                                                  .withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: ProductCardWithDetails(
                                            image: product.images?.first,
                                            price: product.price.toString(),
                                            rate: product.rating.toString(),
                                            name: product.title,
                                            inCart: true,
                                            id: product.id.toString(),
                                            isFavourite: isProductInFav,
                                            onIncrement: () => context
                                                .read<GetProductsCubit>()
                                                .updateQuantity(index, true),
                                            onDecrement: () => context
                                                .read<GetProductsCubit>()
                                                .updateQuantity(index, false),
                                            onDelete: () => context
                                                .read<DeleteProductCubit>()
                                                .deleteCartProduct(
                                                  id: product.id.toString(),
                                                ),
                                            quantity: product.quantity,
                                          ),
                                        ),
                                        SizedBox(height: 14),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            Card(
                              elevation: 1,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Suptotal (${state.cartProducts.length} items)',
                                          style: AppTextStyles.heading3,
                                        ),
                                        Text(
                                          'EGP ${state.totalAmount.toStringAsFixed(2)}',
                                          style: AppTextStyles.heading3,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    PrimaryButtonWidget(
                                      text: 'Checkout',
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return SizedBox(
                height: 60,
                child: Center(child: Text('Cart has no product !!')),
              );
            }
          },
        ),
      ),
    );
  }
}
