import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/api/end_points.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';
import 'package:marketi_app/core/services/service_locator.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/cart/presentation/screens/cart_content.dart';
import 'package:marketi_app/features/favorite/presentation/screens/favourites_content.dart';
import 'package:marketi_app/features/home/presentation/screens/home_pages/home_content_page.dart';
import 'package:marketi_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:marketi_app/features/profile/presentation/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  int? currentIndex;
  HomePage({super.key, this.currentIndex=0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> pages = [
    HomeScreen(),
    CartScreen(),
    // favourites screen,
    FavouriteScreen(),
    // MenuScreen(),
    BlocProvider(
      create: (context) => ProfileCubit(profileRepository: serviceLocator()),
      child: ProfilePage(),
    ),
  ];

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
            onTap: () {
              setState(() {
                widget.currentIndex = 3;
              });
            },
            child: CircleAvatar(
              backgroundColor: AppColors.lightBlueColor,
              foregroundColor: AppColors.navyColor,
              child: const Icon(Icons.person_2_outlined, size: 30),
            ),
          ),
        ),
        title: Text(
          widget.currentIndex == 0
              ? 'Hi $userName !'
              : widget.currentIndex == 1
              ? 'Cart'
              : widget.currentIndex == 2
              ? 'Favorites'
              : 'My Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      body: pages[widget.currentIndex ?? 0],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex ?? 0,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.greyScaleColor,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
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
}
