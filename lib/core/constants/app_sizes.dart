// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppSizes {
  final BuildContext context;
  AppSizes({required this.context});
  double get screenHeight => MediaQuery.heightOf(context);
  double get screenWidth => MediaQuery.widthOf(context);
}
