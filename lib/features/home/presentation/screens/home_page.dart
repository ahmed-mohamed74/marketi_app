import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/api/end_points.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';
import 'package:marketi_app/core/services/service_locator.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marketi_app/features/cart/presentation/screens/cart_content.dart';
import 'package:marketi_app/features/favorite/presentation/screens/favourites_content.dart';
import 'package:marketi_app/features/home/presentation/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:marketi_app/features/home/presentation/screens/home_pages/home_content_page.dart';
import 'package:marketi_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:marketi_app/features/profile/presentation/screens/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      const CartScreen(),
      const FavouriteScreen(),
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProfileCubit(profileRepository: serviceLocator()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(authRepository: serviceLocator()),
          ),
        ],
        child: const ProfilePage(),
      ),
    ];

    var userName = 'User';
    final userString = CacheHelper().getData(key: ApiKey.user);
    if (userString != null) {
      final userMap = jsonDecode(userString);
      userName = userMap['name'];
    }

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () => context.read<NavigationCubit>().updateIndex(3),
                child: CircleAvatar(
                  child: const Icon(Icons.person_2_outlined, size: 30),
                ),
              ),
            ),
            title: Text(
              _getAppBarTitle(currentIndex, userName),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) =>
                context.read<NavigationCubit>().updateIndex(index),
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
      },
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
