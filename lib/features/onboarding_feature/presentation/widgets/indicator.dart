import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 7),
      height: 10,
      width: isActive ? 26 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.darkBlueColor : AppColors.lightBlueColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
