import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/common/widgets/loader.dart';
import 'package:marketi_app/core/common/widgets/primary_button_widget.dart';
import 'package:marketi_app/core/constants/app_routes.dart';
import 'package:marketi_app/core/constants/asset_images.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/auth_feature/views/bloc/auth_bloc.dart';
import 'package:marketi_app/features/auth_feature/views/widgets/authTextFieldWidget.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;
  const NewPasswordPage({super.key, required this.email});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text('Create New Password', style: AppTextStyles.appBarTitle1),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is AuthCreateNewPasswordSuccess) {
            context.go(AppRoutes.congratulationPage);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    Image.asset(
                      AssetImages.createNewPasswordImage,
                      fit: BoxFit.cover,
                      cacheHeight: 200,
                    ),
                    SizedBox(height: 22),
                    Text(
                      'New password must be different from last password',
                      style: AppTextStyles.heading3,
                    ),
                    SizedBox(height: 22),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Password', style: AppTextStyles.bodySmall),
                        AuthTextFieldWidget(
                          hintText: 'Enter New Password',
                          controller: passwordController,
                          icon: Icons.lock_outline,
                          isObscureText: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confirm Password',
                          style: AppTextStyles.bodySmall,
                        ),
                        AuthTextFieldWidget(
                          hintText: 'Confirm New Password',
                          controller: confirmPasswordController,
                          icon: Icons.lock_outline,
                          isObscureText: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 22),
                    (state is AuthLoading)
                        ? Loader()
                        : PrimaryButtonWidget(
                            text: 'Save Password',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  AuthConfirmResetPassword(
                                    email: widget.email,
                                    passsword: passwordController.text.trim(),
                                    confirmPasssword: confirmPasswordController
                                        .text
                                        .trim(),
                                  ),
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
