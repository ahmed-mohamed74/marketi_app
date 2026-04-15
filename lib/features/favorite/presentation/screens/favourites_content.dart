import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home/presentation/widgets/product_card_widget.dart';
import 'package:marketi_app/features/home/presentation/widgets/search_section_widget.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetFavouriteCubit>().getFavouriteProducts();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddFavouriteCubit, AddFavouriteState>(
          listener: (context, state) {
            if (state is AddFavouriteProductSuccess) {
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
      child: BlocBuilder<GetFavouriteCubit, GetFavouriteState>(
        builder: (context, state) {
          final bool isLoading = state is GetFavouritesProductsLoading;

          if (!isLoading &&
              state is GetFavouritesProductsSuccess &&
              state.favouriteProducts.isEmpty) {
            return _buildEmptyState();
          }

          final List<ProductModel> displayedProducts = isLoading
              ? List.generate(
                  6,
                  (index) => ProductModel(
                    id: index,
                    title: "Loading Product Title",
                    price: 100.0,
                    rating: 4.5,
                    images: ["https://via.placeholder.com/150"],
                  ),
                )
              : (state is GetFavouritesProductsSuccess
                    ? state.favouriteProducts
                    : []);

          return Skeletonizer(
            enabled: isLoading,
            containersColor: AppColors.lightBlueColor.withValues(alpha: 0.6),
            ignoreContainers: true,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchSectionWidget(products: displayedProducts),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.86,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                    itemCount: displayedProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayedProducts[index];
                      return GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => context.push(
                                AppRoutes.productPage,
                                extra: product,
                              ),
                        child: ProductCardWidget(
                          product: product,
                          isFavourite: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
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
            Icons.favorite_border,
            size: 100,
            color: AppColors.greyScaleColor,
          ),
          const SizedBox(height: 20),
          Text('Your favorite screen is empty!', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
