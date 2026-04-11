import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/product_card_widget.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/search_section_widget.dart';

class AllProductsPage extends StatefulWidget {
  final String appBarTitle;
  const AllProductsPage({super.key, required this.appBarTitle});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final ScrollController _scrollController = ScrollController();
  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    homeCubit.getAllProducts();
    context.read<GetFavouriteCubit>().getFavouriteProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        // fetch more when close to bottom
        if (homeCubit.state.allProductsStatus != RequestStatus.loading) {
          homeCubit.getAllProducts(loadMore: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text(widget.appBarTitle, style: AppTextStyles.appBarTitle1),
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
          BlocListener<AddProductCubit, AddProductState>(
            listener: (context, state) {
              if (state is AddCartProductSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
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
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, homeState) {
            final items = homeState.allProducts;

            if (homeState.allProductsStatus == RequestStatus.loading &&
                items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (homeState.allProductsStatus == RequestStatus.error &&
                items.isEmpty) {
              return Center(child: Text(homeState.allProductsError ?? 'Error'));
            }

            return BlocBuilder<GetFavouriteCubit, GetFavouriteState>(
              builder: (context, favState) {
                final items = homeState.allProducts;
                List<int> favIds = [];
                if (favState is GetFavouritesProductsSuccess) {
                  favIds = favState.favouriteProducts
                      .map((p) => p.id!)
                      .toList();
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SearchSectionWidget(products: items),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.86,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                        itemCount:
                            items.length +
                            (homeState.allProductsStatus ==
                                    RequestStatus.loading
                                ? 2
                                : 0),
                        itemBuilder: (context, index) {
                          if (index >= items.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final product = items[index];
                          final bool isProductInFav = favIds.contains(
                            product.id,
                          );
                          return GestureDetector(
                            onTap: () => context.push(
                              AppRoutes.productPage,
                              extra: product,
                            ),
                            child: ProductCardWidget(
                              product: product,
                              isFavourite:
                                  isProductInFav, // Pass the calculated status
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
