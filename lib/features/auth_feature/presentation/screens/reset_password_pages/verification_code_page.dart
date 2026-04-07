import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/common/widgets/loader.dart';
import 'package:marketi_app/core/common/widgets/primary_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/constants/asset_images.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/auth_feature/presentation/bloc/auth_bloc.dart';
import 'package:marketi_app/features/auth_feature/presentation/widgets/pin_code_field.dart';

class VerificationCodePage extends StatefulWidget {
  final String email;
  const VerificationCodePage({super.key, required this.email});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final formKey = GlobalKey<FormState>();
  String code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.go(AppRoutes.login)),
        leadingWidth: 64,
        title: Text('Verification Code', style: AppTextStyles.appBarTitle1),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is AuthVerifyCodeSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Code verified!')));
            context.push(
              AppRoutes.newPasswordPage,
              extra: widget.email,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Image.asset(
                      AssetImages.verificationCodeImage,
                      fit: BoxFit.cover,
                      cacheHeight: 200,
                    ),
                    SizedBox(height: 22),
                    Text(
                      'Please enter the 4 digit code sent to: You@gmail.com',
                      style: AppTextStyles.heading3,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    PinCodeField(
                      length: 4,
                      onChanged: (val) {
                        code = val; // store current 4-digit code
                      },
                    ),
                    SizedBox(height: 22),
                    (state is AuthLoading)
                        ? Loader()
                        : PrimaryButtonWidget(
                            text: 'Verify Code',
                            onPressed: () {
                              if (code.length < 4) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter the 4-digit code',
                                    ),
                                  ),
                                );
                                return;
                              }
                              context.read<AuthBloc>().add(
                                AuthVerifyCode(email: widget.email, code: code),
                              );
                            },
                          ),
                    SizedBox(height: 18),
                    TextButton(
                      onPressed: () {
                        // Resend code
                        context.read<AuthBloc>().add(
                          AuthRestPassword(email: widget.email),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Verification code resent!'),
                          ),
                        );
                      },
                      child: const Text(
                        'Resend Code',
                        style: AppTextStyles.heading2,
                      ),
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
