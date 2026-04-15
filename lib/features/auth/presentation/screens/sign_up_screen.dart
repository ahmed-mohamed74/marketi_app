import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/constants/asset_images.dart';
import 'package:marketi_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marketi_app/features/auth/presentation/widgets/authTextFieldWidget.dart';

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
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    confirmPasswordController.dispose();
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
            } else if (state is AuthSignUpSuccess) {
              context.go(AppRoutes.login);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final theme = Theme.of(context);
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        Image.asset(
                          AssetImages.marketiLogo,
                          fit: BoxFit.cover,
                          height: 160,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your Name', style: theme.textTheme.bodySmall),
                            SizedBox(height: 5),
                            AuthTextFieldWidget(
                              hintText: 'Full Name',
                              controller: nameController,
                              icon: Icons.person,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone Number',
                              style: theme.textTheme.bodySmall,
                            ),
                            SizedBox(height: 5),
                            AuthTextFieldWidget(
                              hintText: '+20 1234567891',
                              controller: phoneNumberController,
                              icon: Icons.phone_android,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email', style: theme.textTheme.bodySmall),
                            SizedBox(height: 5),
                            AuthTextFieldWidget(
                              hintText: 'you@gmail.com',
                              controller: emailController,
                              icon: Icons.email_outlined,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Password', style: theme.textTheme.bodySmall),
                            SizedBox(height: 5),
                            AuthTextFieldWidget(
                              hintText: 'Enter Password',
                              controller: passwordController,
                              isObscureText: true,
                              icon: Icons.lock_outline,
                              hasPostIcon: true,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Confirm Password',
                              style: theme.textTheme.bodySmall,
                            ),
                            SizedBox(height: 5),
                            AuthTextFieldWidget(
                              hintText: 'confirm Password',
                              controller: confirmPasswordController,
                              isObscureText: true,
                              icon: Icons.lock_outline,
                              hasPostIcon: true,
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        (state is AuthLoading)
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                child:Text('Sign Up') ,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      AuthSignUp(
                                        name: nameController.text.trim(),
                                        phone: phoneNumberController.text
                                            .trim(),
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                        confirmPassword:
                                            confirmPasswordController.text
                                                .trim(),
                                      ),
                                    );
                                  }
                                },
                              ),
                      ],
                    ),
                    Positioned(
                      top: 30,
                      child: BackButtonWidget(
                        onPressed: () {
                          context.go(AppRoutes.login);
                        },
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
