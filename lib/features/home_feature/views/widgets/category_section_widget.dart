import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/constants/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/view_model/models/category_model.dart';

class CategoryBrandSectionWidget extends StatelessWidget {
  final List<CategoryBrandModel> items;
  final bool isBrand;
  const CategoryBrandSectionWidget({
    super.key,
    this.isBrand = false,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isBrand ? 120 : 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.push(AppRoutes.categoryPage);
            },
            child: Padding(
              padding: isBrand ? EdgeInsets.only(right: 8.0) : EdgeInsets.zero,
              child: SizedBox(
                width: 105,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.lightBlueColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              items[index].image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    isBrand ? Container() : SizedBox(height: 2),
                    isBrand
                        ? Container()
                        : Text(
                            items[index].name,
                            style: AppTextStyles.bodyMedium,
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
