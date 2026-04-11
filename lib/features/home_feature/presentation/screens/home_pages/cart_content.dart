import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/constants/app_sizes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/delete_product_cubit/delete_product_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/get_product_cubit/get_products_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/product_card_widget.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = AppSizes(context: context).screenHeight;
    final screenWidth = AppSizes(context: context).screenWidth;
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
      body: BlocListener<DeleteProductCubit, DeleteProductState>(
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
        child: BlocBuilder<GetProductsCubit, GetProductsState>(
          builder: (context, state) {
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
              return SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 14),
                      Text('Products on Cart', style: AppTextStyles.heading1),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        child: SizedBox(
                          height: screenHeight * 0.75,
                          child: ListView.builder(
                            itemCount: state.cartProducts.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: AppColors.lightBlueColor
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: ProductCard(
                                      image: state
                                          .cartProducts[index]
                                          .images
                                          ?.first,
                                      price: state.cartProducts[index].price
                                          .toString(),
                                      rate: state.cartProducts[index].rating
                                          .toString(),
                                      name: state.cartProducts[index].title,
                                      inCart: true,
                                      id: state.cartProducts[index].id
                                          .toString(),
                                    ),
                                  ),
                                  SizedBox(height: 14),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
