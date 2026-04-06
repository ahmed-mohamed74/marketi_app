import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/view_model/models/product_model.dart';

class ProductsSectionWidget extends StatelessWidget {
  final List<ProductModel> popularProducts;
  final bool withAddButton;

  const ProductsSectionWidget({
    super.key,
    this.withAddButton = false,
    required this.popularProducts,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: withAddButton ? 200 : 160,
      child: ListView.builder(
        itemCount: popularProducts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              width: 150, // ✅ VERY IMPORTANT
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlueColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:
                                  popularProducts[index].images?.first != null
                                  ? Image.network(
                                      popularProducts[index].images!.first,
                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => Image.asset(
                                            'assets/images/product2_image.png',
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.contain,
                                          ),
                                    )
                                  : Image.asset(
                                      'assets/images/product2_image.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                            ),

                            Positioned(
                              top: 4,
                              right: 4,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: Icon(
                                  Icons.favorite_border_outlined,
                                  color: AppColors.darkBlueColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '${popularProducts[index].price?.toString()} LE',
                            style: AppTextStyles.bodySmall,
                          ),
                          Spacer(),
                          const Icon(Icons.star_border, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            popularProducts[index].rating?.toString() ?? '0.0',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      Text(
                        popularProducts[index].title ?? 'Product Name',
                        style: AppTextStyles.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),

                      /// ➕ BUTTON
                      if (withAddButton) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                color: AppColors.primaryColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Add',
                              style: AppTextStyles.heading3.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
