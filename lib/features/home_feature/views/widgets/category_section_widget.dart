import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/view_model/models/brand_model.dart';
import 'package:marketi_app/features/home_feature/view_model/models/category_model.dart';

class CategoryBrandSectionWidget extends StatelessWidget {
  final List<CategoryModel> categories;
  final List<BrandModel> brands;
  final bool isBrand;
  const CategoryBrandSectionWidget({
    super.key,
    this.isBrand = false,
    required this.categories,
    required this.brands,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isBrand ? 120 : 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: isBrand ? brands.length : categories.length,
        itemBuilder: (context, index) {
          return Padding(
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
                            isBrand
                                ? brands[index].brandImage
                                : categories[index].categoryImage,
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
                          categories[index].categoryName,
                          style: AppTextStyles.bodyMedium,
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
