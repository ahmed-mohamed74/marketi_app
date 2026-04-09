// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String image;
  final String price;
  final String rate;
  bool inCart;
  ProductCard({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.rate,
    this.inCart = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        name,
                        style: AppTextStyles.heading3,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Icon(Icons.favorite_border, color: AppColors.darkBlueColor),
                  ],
                ),

                const SizedBox(height: 4),

                /// Subtitle
                Text(
                  "84 Diapers",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.greyScaleColor,
                  ),
                ),
                const SizedBox(height: 6),
                inCart
                    ? Container()
                    : Row(
                        children: const [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Deliver in 60 mins",
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price: $price,00 EGP", style: AppTextStyles.heading3),
                    Row(
                      children: [
                        const Icon(Icons.star_border, size: 18),
                        const SizedBox(width: 2),
                        Text(rate, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                inCart
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.lightBlueColor
                                .withValues(alpha: 0.3),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.delete_outlined,
                                color: AppColors.darkRedColor,
                              ),
                            ),
                          ),
                          Text(
                            '1',
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: AppColors.lightBlueColor
                                .withValues(alpha: 0.3),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 35,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Add",
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
