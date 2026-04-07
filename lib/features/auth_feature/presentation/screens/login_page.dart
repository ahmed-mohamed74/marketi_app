import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/loader.dart';
import 'package:marketi_app/core/common/widgets/primary_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/constants/asset_images.dart';
import 'package:marketi_app/core/routing/app_state_service.dart';
import 'package:marketi_app/core/services/service_locator.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/auth_feature/presentation/bloc/auth_bloc.dart';
import 'package:marketi_app/features/auth_feature/presentation/widgets/authTextFieldWidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
            } else if (state is AuthLoginSuccess) {
              serviceLocator<AppStateService>().login();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 60),
                    Image.asset(AssetImages.marketiLogo, fit: BoxFit.cover),
                    AuthTextFieldWidget(
                      hintText: 'Username or Email',
                      controller: emailController,
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: 15),
                    AuthTextFieldWidget(
                      hintText: 'Password',
                      controller: passwordController,
                      isObscureText: true,
                      icon: Icons.lock_outline,
                      hasPostIcon: true,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Checkbox(
                          side: BorderSide(width: 1),
                          activeColor: AppColors.primaryColor,
                          value: context.watch<AuthBloc>().isChecked,
                          onChanged: (value) {
                            context.read<AuthBloc>().changeCheckBox(value!);
                          },
                        ),
                        const Text(
                          "Remember me",
                          style: TextStyle(
                            color: AppColors.greyScaleColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(child: Container()),
                        TextButton(
                          onPressed: () {
                            context.go(AppRoutes.resetPage);
                          },
                          child: const Text(
                            "Forget Password?",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    (state is AuthLoading)
                        ? Loader()
                        : PrimaryButtonWidget(
                            text: 'Log In',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  AuthLogin(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                          ),
                    SizedBox(height: 14),
                    Text('Or Continue With', style: AppTextStyles.bodyText),
                    SizedBox(height: 14),
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
                    SizedBox(height: 14),
                    GestureDetector(
                      onTap: () {
                        context.go(AppRoutes.signUp);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Are you new in Marketi ",
                          style: AppTextStyles.bodyText,
                          children: [
                            TextSpan(
                              text: 'register?',
                              style: AppTextStyles.bodyText.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
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
