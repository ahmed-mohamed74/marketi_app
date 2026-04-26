import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/home/data/models/brand_model.dart';
import 'package:marketi_app/features/home/data/models/category_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryBrandSectionWidget extends StatelessWidget {
  final List<CategoryModel> categoryItems;
  final List<BrandModel> brandItems;
  final bool isBrand;
  const CategoryBrandSectionWidget({
    super.key,
    this.isBrand = false,
    required this.categoryItems,
    required this.brandItems,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isBrand ? 120 : 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: isBrand
            ? (brandItems.length / 3).toInt()
            : (categoryItems.length / 3).toInt(),
        itemBuilder: (context, index) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  isBrand
                      ? context.push(
                          AppRoutes.brandPage,
                          extra: brandItems[index].name,
                        )
                      : context.push(
                          AppRoutes.categoryPage,
                          extra: categoryItems[index].name,
                        );
                },
                child: Padding(
                  padding: isBrand
                      ? EdgeInsets.only(right: 8.0)
                      : EdgeInsets.zero,
                  child: SizedBox(
                    width: 105,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: 150,
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
                                  child: isBrand
                                      ? Text(
                                          brandItems[index].emoji!,
                                          style: TextStyle(fontSize: 40),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: categoryItems[index].image,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.contain,
                                          fadeInDuration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          placeholder: (context, url) {
                                            return Skeletonizer(
                                              containersColor:
                                                  Colors.grey[300]!,
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                          errorWidget: (context, url, error) {
                                            return Image.asset(
                                              'assets/images/default_image.png',
                                              fit: BoxFit.contain,
                                            );
                                          },
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        isBrand ? Container() : SizedBox(height: 2),
                        isBrand
                            ? Container()
                            : Text(
                                overflow: TextOverflow.ellipsis,
                                categoryItems[index].name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          );
        },
      ),
    );
  }
}
