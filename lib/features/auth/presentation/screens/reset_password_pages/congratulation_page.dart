import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/constants/asset_images.dart';

class CongratulationPage extends StatelessWidget {
  const CongratulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(
          onPressed: () {
            context.go(AppRoutes.login);
          },
        ),
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
            Text('Congratulations', style: theme.textTheme.bodyLarge),
            SizedBox(height: 30),
            Text(
              'You have updated the password. please login again with your latest password',
              style: theme.textTheme.titleSmall,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Log In'),
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
