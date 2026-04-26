import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';
import 'package:marketi_app/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:marketi_app/features/home/presentation/widgets/product_card_widget.dart';
import 'package:marketi_app/features/home/presentation/widgets/search_section_widget.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Add this
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';

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
    context.read<GetFavouriteCubit>().getFavouriteProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
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
        title: Text(
          widget.appBarTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  context.go(AppRoutes.profile);
                });
              },
              child: CircleAvatar(
                child: Icon(Icons.person_2_outlined, size: 30),
              ),
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
                  const SnackBar(content: Text("Removed from favorites")),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, homeState) {
            final items = homeState.allProducts;

            // 1. Determine if we are doing the INITIAL load
            final bool isInitialLoading =
                homeState.allProductsStatus == RequestStatus.loading &&
                items.isEmpty;

            // 2. Prepare data for Skeletonizer (Real items or Dummy items)
            final List<ProductModel> displayedProducts = isInitialLoading
                ? List.generate(
                    6,
                    (index) => ProductModel(
                      id: index,
                      title: "Loading Name",
                      price: 0.0,
                      images: ["https://via.placeholder.com/150"],
                    ),
                  )
                : items;

            if (homeState.allProductsStatus == RequestStatus.error &&
                items.isEmpty) {
              return Center(child: Text(homeState.allProductsError ?? 'Error'));
            }

            return BlocBuilder<GetFavouriteCubit, GetFavouriteState>(
              builder: (context, favState) {
                List<int> favIds = [];
                if (favState is GetFavouritesProductsSuccess) {
                  favIds = favState.favouriteProducts
                      .map((p) => p.id!)
                      .toList();
                }

                return Skeletonizer(
                  enabled: isInitialLoading,
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
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.86,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                          // Add extra items only if NOT in skeleton mode and currently loading more
                          itemCount: isInitialLoading
                              ? displayedProducts.length
                              : (displayedProducts.length +
                                    (homeState.allProductsStatus ==
                                            RequestStatus.loading
                                        ? 2
                                        : 0)),
                          itemBuilder: (context, index) {
                            // Show spinner at the bottom during pagination
                            if (index >= displayedProducts.length) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final product = displayedProducts[index];
                            final bool isProductInFav = favIds.contains(
                              product.id,
                            );

                            return GestureDetector(
                              onTap: isInitialLoading
                                  ? null
                                  : () => context.push(
                                      AppRoutes.productPage,
                                      extra: product,
                                    ),
                              child: ProductCardWidget(
                                product: product,
                                isFavourite: isProductInFav,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
