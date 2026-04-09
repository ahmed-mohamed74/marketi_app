import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/data/models/brand_model.dart';
import 'package:marketi_app/features/home_feature/data/models/category_model.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/home_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/widgets/search_section_widget.dart';

class AllCategoryBrandsPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text(
          (appBarTitle == 'Category') ? 'Categories' : 'Brands',
          style: AppTextStyles.appBarTitle1,
        ),
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
                    products: (appBarTitle == 'Category')
                        ? state.productsByCategory
                        : state.productsByBrand,
                  );
                },
              ),
              SizedBox(height: 10),
              Text(
                (appBarTitle == 'Category') ? 'All Categories' : 'All Brands',
                style: AppTextStyles.heading1,
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
                  itemCount: (appBarTitle == 'Category')
                      ? categoryItems.length
                      : brandItems.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        (appBarTitle == 'Category')
                            ? context.push(
                                AppRoutes.categoryPage,
                                extra: categoryItems[index].name,
                              )
                            : context.push(
                                AppRoutes.brandPage,
                                extra: brandItems[index].name,
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
                                    child: (appBarTitle == 'Category')
                                        ? Image.network(
                                            categoryItems[index].image,
                                            fit: BoxFit.contain,
                                          )
                                        : Text(
                                            brandItems[index].emoji ?? '',
                                            style: TextStyle(fontSize: 35),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            (appBarTitle == 'Category')
                                ? categoryItems[index].name
                                : brandItems[index].name!,
                            style: AppTextStyles.bodyMedium,
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
