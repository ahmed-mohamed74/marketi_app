import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsSectionWidget extends StatelessWidget {
  final List<ProductModel> popularProducts;
  final bool withAddButton;

  const ProductsSectionWidget({
    super.key,
    this.withAddButton = false,
    required this.popularProducts,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: withAddButton ? 200 : 160,
      child: ListView.builder(
        itemCount: popularProducts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final product = popularProducts[index];
          return BlocBuilder<GetFavouriteCubit, GetFavouriteState>(
            builder: (context, favState) {
              bool isFav = false;
              if (favState is GetFavouritesProductsSuccess) {
                isFav = favState.favouriteProducts.any(
                  (p) => p.id == product.id,
                );
              }
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.productPage, extra: product);
                  },
                  child: SizedBox(
                    width: 150,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                                      imageUrl: popularProducts[index]
                                          .images!
                                          .first
                                          .trim(),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                      fadeInDuration: const Duration(
                                        milliseconds: 500,
                                      ),
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
                                        final productId = product.id.toString();

                                        if (isFav) {
                                          context
                                              .read<DeleteFavouriteCubit>()
                                              .deleteFavouriteProduct(
                                                id: productId,
                                              );
                                        } else {
                                          context
                                              .read<AddFavouriteCubit>()
                                              .addFavouriteProduct(
                                                id: productId,
                                              );
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 15,
                                        child: Icon(
                                          isFav
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined,
                                          color: isFav
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
                                  '${popularProducts[index].price?.toString()} LE',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Spacer(),
                                const Icon(Icons.star_border, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  popularProducts[index].rating?.toString() ??
                                      '0.0',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Text(
                              popularProducts[index].title ?? 'Product Name',
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),

                            /// ➕ BUTTON
                            if (withAddButton) ...[
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: 30,
                                child: OutlinedButton(
                                  onPressed: () {
                                    context
                                        .read<AddProductCubit>()
                                        .addCartProduct(
                                          id: popularProducts[index].id
                                              .toString(),
                                        );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: AppColors.primaryColor,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Text(
                                    'Add',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: AppColors.primaryColor,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
