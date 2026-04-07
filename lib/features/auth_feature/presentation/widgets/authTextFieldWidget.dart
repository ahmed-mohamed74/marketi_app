import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';

class AuthTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscureText;
  final IconData icon;
  final bool hasPostIcon;
  const AuthTextFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    required this.icon,
    this.hasPostIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.hintText,
        prefixIcon: Icon(icon),
        suffixIcon: hasPostIcon ? Icon(Icons.visibility_off) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.lightBlueColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.lightBlueColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
