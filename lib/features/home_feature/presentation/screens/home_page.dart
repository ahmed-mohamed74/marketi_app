import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/services/service_locator.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/delete_product_cubit/delete_product_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/cart_cubits/get_product_cubit/get_products_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/screens/home_pages/cart_content.dart';
import 'package:marketi_app/features/home_feature/presentation/screens/home_pages/home_content_page.dart';
import 'package:marketi_app/features/profile_feature/presentation/cubit/profile_cubit.dart';
import 'package:marketi_app/features/profile_feature/presentation/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    CartScreen(),
    // favourites screen,
    Scaffold(),
    // MenuScreen(),
    BlocProvider(
      create: (context) => ProfileCubit(profileRepository: serviceLocator()),
      child: ProfilePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.greyScaleColor,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
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
