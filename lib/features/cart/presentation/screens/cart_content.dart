import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';
import 'package:marketi_app/features/order/data/models/order_model.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Added Import
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/delete_product_cubit/delete_product_cubit.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/get_product_cubit/get_products_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home/presentation/widgets/product_card_with_details_widget.dart';

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
    return MultiBlocListener(
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Products on Cart',
                        style: Theme.of(context).textTheme.displayMedium,
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
                                    color: AppColors.lightBlueColor.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: ProductCardWithDetails(
                                  image: product?.images?.first,
                                  price: product?.price.toString() ?? "000.00",
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
                      isLoading
                          ? []
                          : (state as GetCartProductsSuccess).cartProducts,
                      isLoading,
                    ),
                  ],
                );
              },
            ),
          );
        },
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
          Text(
            'Your cart is empty!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(
    double total,
    List<dynamic> products,
    bool isLoading,
  ) {
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
                  'Subtotal (${products.length} items)',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'EGP ${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: isLoading || products.isEmpty
                  ? null
                  : () {
                      final List<ProductModel> cartProductsList = products
                          .cast<ProductModel>()
                          .toList();

                      final order = OrderModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        products: cartProductsList,
                        totalPrice: total,
                        date: DateTime.now(),
                      );
                      context.push(AppRoutes.checkoutPage, extra: order);
                    },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
