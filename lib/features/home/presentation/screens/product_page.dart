import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel? product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text(
          'Product Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined, size: 30),
              onPressed: () {
                  context.go(AppRoutes.cart);
              },
            ),
          ),
        ],
      ),
      body: BlocListener<AddProductCubit, AddProductState>(
        listener: (context, state) {
          if (state is AddCartProductSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AddCartProductFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Product Image
              Center(
                child: Image.network(
                  widget.product?.images?.first ??
                      'https://placehold.co/300x300.png?text=Pampers+Box', // Replace with your asset
                  height: 250,
                ),
              ),
              const SizedBox(height: 10),
              // Pagination Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(isActive: false),
                  _buildDot(isActive: true, width: 25),
                  _buildDot(isActive: false),
                ],
              ),
              const SizedBox(height: 20),
              // Thumbnails
              Center(
                child: SizedBox(
                  height: 60,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: List.generate(
                      widget.product?.images?.length ?? 1,
                      (index) => _buildThumbnail(
                        image: widget.product?.images?[index],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Badge(text: 'Free Shipping'),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.darkBlueColor,
                              size: 18,
                            ),
                            Icon(
                              Icons.star,
                              color: AppColors.darkBlueColor,
                              size: 18,
                            ),
                            Icon(
                              Icons.star,
                              color: AppColors.darkBlueColor,
                              size: 18,
                            ),
                            Icon(
                              Icons.star,
                              color: AppColors.darkBlueColor,
                              size: 18,
                            ),
                            Icon(
                              Icons.star_border,
                              color: AppColors.darkBlueColor,
                              size: 18,
                            ),
                            Text(
                              ' (4.0)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.product?.title ?? 'Pampers Swaddlers',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Product Value',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.product?.description ??
                          'Fear no leaks with new and improved Pampers Swaddlers. Pampers Swaddlers helps prevent up to 100% of leaks, even blowouts Plus...',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'See more',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Select Size',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        _SizeOption(label: '3'),
                        _SizeOption(label: '2', isSelected: true),
                        _SizeOption(label: '4'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Price', style: Theme.of(context).textTheme.titleLarge),
                Text(
                  widget.product?.price?.toString() ?? '345.00 EGP',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<AddProductCubit>().addCartProduct(
                    id: widget.product?.id.toString() ?? '0',
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: Text(
                  'Add to Cart',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryColor,
                  side: const BorderSide(color: AppColors.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive, double width = 8}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 4,
      width: width,
      decoration: BoxDecoration(
        color: isActive ? AppColors.darkBlueColor : AppColors.lightBlueColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildThumbnail({required String? image}) {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightBlueColor),
        image: DecorationImage(
          image: NetworkImage(image ?? 'https://placehold.co/60x60.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall!.copyWith(color: AppColors.primaryColor),
      ),
    );
  }
}

class _SizeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _SizeOption({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : AppColors.lightBlueColor,
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 24,
              color: isSelected
                  ? AppColors.darkBlueColor
                  : AppColors.darkBlueColor.withValues(alpha: 0.7),
            ),
          ),

          if (isSelected)
            Positioned(
              bottom: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
