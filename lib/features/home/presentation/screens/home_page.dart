import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/api/end_points.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/get_product_cubit/get_products_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:marketi_app/features/profile/presentation/cubit/profile_cubit.dart';

class HomePage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const HomePage({super.key, required this.navigationShell});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeCubit>();
    cubit.getPopularProducts();
    cubit.getBestProducts();
    cubit.getBuyAgainProducts();
    cubit.getCategories();
    cubit.getBrands();
    context.read<GetFavouriteCubit>().getFavouriteProducts();
    context.read<GetProductsCubit>().getCartProducts();
    context.read<ProfileCubit>().getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var userName = 'User';
    final userString = CacheHelper().getData(key: ApiKey.user);
    if (userString != null) {
      final userMap = jsonDecode(userString);
      userName = userMap['name'];
    }

    return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () => widget.navigationShell.goBranch(3),
                child: CircleAvatar(
                  child: const Icon(Icons.person_2_outlined, size: 30),
                ),
              ),
            ),
            title: Text(
              _getAppBarTitle(widget.navigationShell.currentIndex, userName),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: widget.navigationShell,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: widget.navigationShell.currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) => widget.navigationShell.goBranch(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Cart',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Fav'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                label: 'Profile',
              ),
            ],
          ),
        );
      
  }

  String _getAppBarTitle(int index, String userName) {
    switch (index) {
      case 0:
        return 'Hi $userName !';
      case 1:
        return 'Cart';
      case 2:
        return 'Favorites';
      default:
        return 'My Profile';
    }
  }
}
