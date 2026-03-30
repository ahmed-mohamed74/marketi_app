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

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(
          onPressed: () {
            context.go(AppRoutes.login);
          },
        ),
        leadingWidth: 64,
        title: Text('Forgot Password', style: AppTextStyles.appBarTitle1),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is AuthResetPasswordSuccess) {
            context.go(AppRoutes.verificationPage);
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
                      AssetImages.forgotPasswordImage,
                      fit: BoxFit.cover,
                      cacheHeight: 200,
                    ),
                    SizedBox(height: 22),
                    Text(
                      'Please enter your email address to receive a verification code',
                      style: AppTextStyles.heading3,
                    ),
                    SizedBox(height: 22),
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
                    SizedBox(height: 22),
                    (state is AuthLoading)
                        ? Loader()
                        : PrimaryButtonWidget(
                            text: 'Send Code',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  AuthRestPassword(
                                    email: emailController.text.trim(),
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
