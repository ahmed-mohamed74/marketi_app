import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final bool isFavourite;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.isFavourite = false,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightBlueColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: product.images!.first,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                      fadeInDuration: const Duration(milliseconds: 500),
                      placeholder: (context, url) {
                        return Skeletonizer(
                          containersColor: Colors.grey[300]!,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Image.asset(
                          'assets/images/default_image.png',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        if (isFavourite) {
                          context
                              .read<DeleteFavouriteCubit>()
                              .deleteFavouriteProduct(
                                id: product.id.toString(),
                              );
                        } else {
                          context.read<AddFavouriteCubit>().addFavouriteProduct(
                            id: product.id.toString(),
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(
                          isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: isFavourite
                              ? Colors.black
                              : AppColors.darkBlueColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '${product.price ?? 499} LE',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                const Icon(Icons.star_border, size: 14),
                const SizedBox(width: 2),
                Text(
                  '${product.rating ?? 4.9}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Text(
              product.title ?? 'Smart Watch',
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              height: 30,
              child: OutlinedButton(
                onPressed: () {
                  context.read<AddProductCubit>().addCartProduct(
                    id: product.id.toString(),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Add',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
