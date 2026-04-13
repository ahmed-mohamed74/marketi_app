import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/features/home_feature/data/models/product_model.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Added Import
import 'package:marketi_app/core/common/widgets/primary_button_widget.dart';
import 'package:marketi_app/core/constants/app_sizes.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
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
                  const SnackBar(content: Text("Removed from favorites")),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<GetProductsCubit, GetProductsState>(
          builder: (context, state) {
            // 1. Logic to handle Loading vs Success
            final bool isLoading = state is GetCartProductsLoading;

            if (!isLoading &&
                state is GetCartProductsSuccess &&
                state.cartProducts.isEmpty) {
              return _buildEmptyState();
            }

            // 2. Prepare data for Skeletonizer (Real products or Dummy placeholders)
            final cartProducts = isLoading
                ? List.generate(
                    5,
                    (index) =>
                        dynamic, // We just need a count; details are hardcoded below
                  )
                : (state as GetCartProductsSuccess).cartProducts;

            final totalAmount = state is GetCartProductsSuccess
                ? state.totalAmount
                : 0.0;

            return Skeletonizer(
              enabled: isLoading,
              child: BlocBuilder<GetFavouriteCubit, GetFavouriteState>(
                builder: (context, favState) {
                  List<int> favIds = [];
                  if (favState is GetFavouritesProductsSuccess) {
                    favIds = favState.favouriteProducts
                        .map((p) => p.id!)
                        .toList();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Products on Cart',
                          style: AppTextStyles.heading1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: cartProducts.length,
                            itemBuilder: (context, index) {
                              // If loading, we pass fake strings to the widget
                              dynamic product = isLoading
                                  ? null
                                  : cartProducts[index];
                              final bool isProductInFav = isLoading
                                  ? false
                                  : favIds.contains(product?.id);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: AppColors.lightBlueColor
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: ProductCardWithDetails(
                                    image: product?.images?.first,
                                    price:
                                        product?.price.toString() ?? "000.00",
                                    rate: product?.rating.toString() ?? "0.0",
                                    name:
                                        product?.title ??
                                        "Product Name Placeholder",
                                    inCart: true,
                                    id:
                                        product?.id.toString() ??
                                        index.toString(),
                                    isFavourite: isProductInFav,
                                    onIncrement: () => !isLoading
                                        ? context
                                              .read<GetProductsCubit>()
                                              .updateQuantity(index, true)
                                        : null,
                                    onDecrement: () => !isLoading
                                        ? context
                                              .read<GetProductsCubit>()
                                              .updateQuantity(index, false)
                                        : null,
                                    onDelete: () => !isLoading
                                        ? context
                                              .read<DeleteProductCubit>()
                                              .deleteCartProduct(
                                                id: product!.id.toString(),
                                              )
                                        : null,
                                    quantity: product?.quantity ?? 1,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      _buildCheckoutSection(
                        totalAmount,
                        cartProducts.length,
                        isLoading,
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: AppColors.greyScaleColor,
          ),
          const SizedBox(height: 20),
          Text('Your cart is empty!', style: AppTextStyles.heading2),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(double total, int itemCount, bool isLoading) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal ($itemCount items)',
                  style: AppTextStyles.heading3,
                ),
                Text(
                  'EGP ${total.toStringAsFixed(2)}',
                  style: AppTextStyles.heading3,
                ),
              ],
            ),
            const SizedBox(height: 14),
            PrimaryButtonWidget(
              text: 'Checkout',
              onPressed: isLoading
                  ? () {}
                  : () {
                      context.push(
                        AppRoutes.checkoutPage,
                        extra: {'amount': total, 'suptotalItems': itemCount},
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
