import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/validators.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/router/route_paths.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/global_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordObscureText = true;
  bool isValidEmail = false;
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Spacing.appPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => context.pop(),
                child: Icon(Icons.arrow_back_ios),
              ),
              _signInForm(context: context),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  // Sigin in form
  Widget _signInForm({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome Back!', style: context.textStyles.headlineLarge),
        const SizedBox(height: 14),
        Text('Sign in to continue', style: context.textStyles.bodyMedium),
        const SizedBox(height: 30),
        Form(
          key: _formKey,
          child: Column(
            children: [
              GlobalTextField(
                controller: emailController,

                textInputType: TextInputType.emailAddress,
                text: 'EMAIL',
                fieldType: TextFormFieldType.email,
                suffixIcon: isValidEmail ? Icon(Icons.check, size: 20) : null,
                onChanged: (val) {
                  final result = Validators.validateField(
                    TextFormFieldType.email,
                    emailController.text,
                  );
                  result == null
                      ? setState(() {
                          isValidEmail = !isValidEmail;
                        })
                      : null;
                },
              ),
              const SizedBox(height: 20),
              GlobalTextField(
                controller: passwordController,

                textInputType: TextInputType.visiblePassword,
                text: 'PASSWORD',
                fieldType: TextFormFieldType.password,
                suffixIcon: InkWell(
                  onTap: () => setState(() {
                    passwordObscureText = !passwordObscureText;
                  }),
                  child: Icon(
                    passwordObscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
                obscureText: passwordObscureText,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (val) => setState(() {
                          rememberMe = !rememberMe;
                        }),
                        side: BorderSide(color: Color(0xffDBE9F5)),
                      ),
                      Text('Remember me', style: context.textStyles.bodyMedium),
                    ],
                  ),
                  InkWell(
                    onTap: () => context.pushNamed(RouteNames.forgetPassword),
                    child: Text(
                      'Forgot password?',
                      style: context.textStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              GlobalButton(
                text: 'SIGN IN',
                onTap: () => _formKey.currentState!.validate()
                    ? context.go(RoutePaths.home)
                    : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Don’t have an account? ',
                    style: context.textStyles.bodyMedium!.copyWith(
                      color: context.colors.secondary,
                    ),
                  ),
                  InkWell(
                    onTap: () => context.pushNamed(RouteNames.signup),
                    child: Text(
                      'Sign up',
                      style: context.textStyles.bodyMedium!.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
