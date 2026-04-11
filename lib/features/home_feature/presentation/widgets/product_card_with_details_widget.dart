// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/constants/app_sizes.dart';

import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/delete_product_cubit/delete_product_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';

class ProductCardWithDetails extends StatelessWidget {
  final String? id;
  final String? name;
  final String? image;
  final String? price;
  final String? rate;
  bool inCart;
  final bool isFavourite;
  ProductCardWithDetails({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.rate,
    this.inCart = false,
    this.isFavourite = false,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: AppSizes(context: context).screenWidth * 0.22,
            height: AppSizes(context: context).screenWidth * 0.22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: image != null
                    ? NetworkImage(image!)
                    : AssetImage('assets/images/product2_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        name ?? 'default',
                        style: AppTextStyles.heading3,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isFavourite) {
                          context
                              .read<DeleteFavouriteCubit>()
                              .deleteFavouriteProduct(id: id!);
                        } else {
                          context.read<AddFavouriteCubit>().addFavouriteProduct(
                            id: id!,
                          );
                        }
                      },
                      child: Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_border,
                        color: isFavourite
                            ? Colors.red
                            : AppColors.darkBlueColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                /// Subtitle
                Text(
                  "84 Diapers",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.greyScaleColor,
                  ),
                ),
                const SizedBox(height: 6),
                inCart
                    ? Container()
                    : Row(
                        children: const [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Deliver in 60 mins",
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price: $price EGP", style: AppTextStyles.heading3),
                    Row(
                      children: [
                        const Icon(Icons.star_border, size: 18),
                        const SizedBox(width: 2),
                        Text(rate ?? '0.0', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                inCart
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.lightBlueColor
                                .withValues(alpha: 0.3),
                            child: IconButton(
                              onPressed: () {
                                context
                                    .read<DeleteProductCubit>()
                                    .deleteCartProduct(id: id ?? '0');
                              },
                              icon: Icon(
                                Icons.delete_outlined,
                                color: AppColors.darkRedColor,
                              ),
                            ),
                          ),
                          Text(
                            '1',
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: AppColors.lightBlueColor
                                .withValues(alpha: 0.3),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 35,
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<AddProductCubit>().addCartProduct(
                              id: id ?? '0',
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Add",
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
