import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const BackButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightBlueColor),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Container(width: 4),
            IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.arrow_back_ios, color: AppColors.darkBlueColor),
              iconSize: 25,
            ),
          ],
        ),
      ),
    );
  }
}
