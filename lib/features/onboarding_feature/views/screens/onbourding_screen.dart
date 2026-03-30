import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/primary_button_widget.dart';
import 'package:marketi_app/core/constants/app_routes.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/onboarding_feature/views/cubit/onbourd_cubit.dart';
import 'package:marketi_app/features/onboarding_feature/view_model/lists/onbourd_list.dart';
import 'package:marketi_app/features/onboarding_feature/views/widgets/indicator.dart';

class OnbourdingScreen extends StatelessWidget {
  const OnbourdingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    final onboardCubit = context.read<OnbourdCubit>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 500,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) => onboardCubit.onPageChanged(value),
                itemCount: onbourdList.length,
                itemBuilder: (context, index) {
                  final item = onbourdList[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(item.imagePath),
                      const SizedBox(height: 42),
                      Text(item.title, style: AppTextStyles.heading1),
                      const SizedBox(height: 34),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(item.desc, style: AppTextStyles.heading3),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<OnbourdCubit, int>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onbourdList.length,
                    (index) => Indicator(isActive: state == index),
                  ),
                );
              },
            ),
            const SizedBox(height: 34),
            BlocBuilder<OnbourdCubit, int>(
              builder: (context, state) {
                final isLast = state == onbourdList.length - 1;
                return PrimaryButtonWidget(
                  text: isLast ? 'Get Start' : 'Next',
                  onPressed: () {
                    if (!isLast) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      onboardCubit.completeOnboarding();
                      GoRouter.of(context).go(AppRoutes.login);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
