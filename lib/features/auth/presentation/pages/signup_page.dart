import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/validators.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/global_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool passwordObscureText = true;

  bool isValidEmail = false;

  final _formKey = GlobalKey<FormState>();

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text('Sign up', style: context.textStyles.headlineLarge),
          const SizedBox(height: 30),
          GlobalTextField(
            controller: nameController,
            textInputType: TextInputType.text,
            text: 'NAME',
            fieldType: TextFormFieldType.name,
          ),
          const SizedBox(height: 20),
          GlobalTextField(
            controller: emailController,
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
            textInputType: TextInputType.emailAddress,
            text: 'EMAIL',
            fieldType: TextFormFieldType.email,
          ),
          const SizedBox(height: 20),
          GlobalTextField(
            controller: passwordController,
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
            textInputType: TextInputType.visiblePassword,
            text: 'PASSWORD',
            fieldType: TextFormFieldType.password,
          ),
          const SizedBox(height: 20),
          GlobalTextField(
            controller: confirmPasswordController,
            validator: (val) {
              return confirmPasswordController.text != passwordController.text
                  ? 'Please Use The Same Password'
                  : null;
            },
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
            textInputType: TextInputType.visiblePassword,
            text: 'CONFIRM PASSWORD',
            fieldType: TextFormFieldType.password,
          ),
          const SizedBox(height: 32),
          GlobalButton(
            text: 'SIGN UP',
            onTap: () => _formKey.currentState!.validate()
                ? context.goNamed(
                    RouteNames.succesPage,
                    extra: {
                      'title': 'Account Created!',
                      'subTitle':
                          'Your account had beed created \n successfully.',
                      'iconPath': 'user_icon',
                      'buttonText': 'SHOP NOW',
                      'destination': 'home',
                    },
                  )
                : null,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Already have an account? ',
                style: context.textStyles.bodyMedium!.copyWith(
                  color: context.colors.secondary,
                ),
              ),
              InkWell(
                onTap: () => context.pushNamed(RouteNames.signin),
                child: Text(
                  'Sign In',
                  style: context.textStyles.bodyMedium!.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
