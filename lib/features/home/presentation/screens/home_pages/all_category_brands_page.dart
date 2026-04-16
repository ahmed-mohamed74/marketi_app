import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/home/data/models/brand_model.dart';
import 'package:marketi_app/features/home/data/models/category_model.dart';
import 'package:marketi_app/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:marketi_app/features/home/presentation/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:marketi_app/features/home/presentation/widgets/search_section_widget.dart';

class AllCategoryBrandsPage extends StatefulWidget {
  final List<CategoryModel> categoryItems;
  final List<BrandModel> brandItems;
  final String appBarTitle;
  const AllCategoryBrandsPage({
    super.key,
    required this.appBarTitle,
    required this.categoryItems,
    required this.brandItems,
  });

  @override
  State<AllCategoryBrandsPage> createState() => _AllCategoryBrandsPageState();
}

class _AllCategoryBrandsPageState extends State<AllCategoryBrandsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text(
          (widget.appBarTitle == 'Category') ? 'Categories' : 'Brands',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions:  [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  context.read<NavigationCubit>().updateIndex(3);
                  context.go(AppRoutes.home);
                });
              },
              child: CircleAvatar(
                child: Icon(Icons.person_2_outlined, size: 30),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return SearchSectionWidget(
                    products: (widget.appBarTitle == 'Category')
                        ? state.productsByCategory
                        : state.productsByBrand,
                  );
                },
              ),
              SizedBox(height: 10),
              Text(
                (widget.appBarTitle == 'Category') ? 'All Categories' : 'All Brands',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 585,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: (widget.appBarTitle == 'Category')
                      ? widget.categoryItems.length
                      : widget.brandItems.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        (widget.appBarTitle == 'Category')
                            ? context.push(
                                AppRoutes.categoryPage,
                                extra: widget.categoryItems[index].name,
                              )
                            : context.push(
                                AppRoutes.brandPage,
                                extra: widget.brandItems[index].name,
                              );
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.lightBlueColor,
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: (widget.appBarTitle == 'Category')
                                        ? Image.network(
                                            widget.categoryItems[index].image,
                                            fit: BoxFit.contain,
                                          )
                                        : Text(
                                            widget.brandItems[index].emoji ?? '',
                                            style: TextStyle(fontSize: 35),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            (widget.appBarTitle == 'Category')
                                ? widget.categoryItems[index].name
                                : widget.brandItems[index].name!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
