import 'package:flutter/material.dart';
import 'package:marketi_app/core/constants/app_sizes.dart';
import 'package:marketi_app/core/themes/colors.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlueColor),
      ),
      child: Column(
        children: [
          Container(
            height: AppSizes(context: context).screenHeight * 0.09,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F4FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(
                  'https://placeholder.com/map_image',
                ), // Replace with actual map static image
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.location_on,
                color: AppColors.primaryColor,
                size: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.darkBlueColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Home',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Anshas, Al-sharqia, Egypt.',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.navyColor,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Mobile: +20 101 840 3043',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.navyColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Change',
                    style: TextStyle(color: AppColors.primaryColor),
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
