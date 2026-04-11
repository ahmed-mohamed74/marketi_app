import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/product_card_widget.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/search_section_widget.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: AppTextStyles.appBarTitle1),
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
        child: BlocBuilder<GetFavouriteCubit, GetFavouriteState>(
          builder: (context, state) {
            if (state is GetFavouritesProductsLoading) {
              return const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is GetFavouritesProductsSuccess) {
              if (state.favouriteProducts.isEmpty) {
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
                        'Your favorite screen is empty!',
                        style: AppTextStyles.heading2,
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchSectionWidget(
                      products: state.favouriteProducts,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.86,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                      itemCount: state.favouriteProducts.length,
                      itemBuilder: (context, index) {
                        final product = state.favouriteProducts[index];
                        return GestureDetector(
                          onTap: () => context.push(
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
              );
            } else {
              return SizedBox(
                height: 60,
                child: Center(child: Text(' You has no favorite products !!')),
              );
            }
          },
        ),
      ),
    );
  }
}
