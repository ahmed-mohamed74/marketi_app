import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/common/widgets/primary_button_widget.dart';
import 'package:marketi_app/core/constants/app_routes.dart';
import 'package:marketi_app/core/constants/asset_images.dart';
import 'package:marketi_app/core/themes/styles.dart';

class CongratulationPage extends StatelessWidget {
  const CongratulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () {}),
        leadingWidth: 64,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            SizedBox(height: 60),
            Image.asset(
              AssetImages.congratulationsImage,
              fit: BoxFit.cover,
              cacheHeight: 200,
            ),
            SizedBox(height: 30),
            Text('Congratulations', style: AppTextStyles.bodyLarge),
            SizedBox(height: 30),
            Text(
              'You have updated the password. please login again with your latest password',
              style: AppTextStyles.heading3,
            ),
            SizedBox(height: 30),
            PrimaryButtonWidget(
              text: 'Log In',
              onPressed: () {
                context.go(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
