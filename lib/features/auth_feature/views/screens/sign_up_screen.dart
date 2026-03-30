import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/loader.dart';
import 'package:marketi_app/core/common/widgets/primary_button_widget.dart';
import 'package:marketi_app/core/constants/app_routes.dart';
import 'package:marketi_app/core/constants/asset_images.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/auth_feature/views/bloc/auth_bloc.dart';
import 'package:marketi_app/features/auth_feature/views/widgets/authTextFieldWidget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            } else if (state is AuthSuccess) {
              GoRouter.of(context).go(AppRoutes.home);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Image.asset(
                          AssetImages.marketiLogo,
                          fit: BoxFit.cover,
                          height: 160,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your Name', style: AppTextStyles.bodySmall),
                            AuthTextFieldWidget(
                              hintText: 'Full Name',
                              controller: nameController,
                              icon: Icons.person,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone Number',
                              style: AppTextStyles.bodySmall,
                            ),
                            AuthTextFieldWidget(
                              hintText: '+20 1234567891',
                              controller: phoneNumberController,
                              icon: Icons.phone_android,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email', style: AppTextStyles.bodySmall),
                            AuthTextFieldWidget(
                              hintText: 'you@gmail.com',
                              controller: emailController,
                              icon: Icons.email_outlined,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Password', style: AppTextStyles.bodySmall),
                            AuthTextFieldWidget(
                              hintText: 'Enter Password',
                              controller: passwordController,
                              isObscureText: true,
                              icon: Icons.lock_outline,
                              hasPostIcon: true,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Confirm Password',
                              style: AppTextStyles.bodySmall,
                            ),
                            AuthTextFieldWidget(
                              hintText: 'confirm Password',
                              controller: confirmPasswordController,
                              isObscureText: true,
                              icon: Icons.lock_outline,
                              hasPostIcon: true,
                            ),
                          ],
                        ),
                        SizedBox(height: 18),
                        (state is AuthLoading)
                            ? Loader()
                            : PrimaryButtonWidget(
                                text: 'Sign Up',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      AuthLogin(
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                      ),
                                    );
                                  }
                                },
                              ),
                        SizedBox(height: 14),
                        Text('Or Continue With', style: AppTextStyles.bodyText),
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.webhook,
                              size: 40,
                              color: AppColors.darkBlueColor,
                            ),
                            Icon(
                              Icons.apple,
                              size: 40,
                              color: AppColors.darkBlueColor,
                            ),
                            Icon(
                              Icons.facebook_outlined,
                              size: 40,
                              color: AppColors.darkBlueColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightBlueColor),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Container(width: 4),
                            IconButton(
                              onPressed: () {
                                context.go(AppRoutes.login);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.darkBlueColor,
                              ),
                              iconSize: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
