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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => context.pop(),
                          child: const Icon(Icons.arrow_back_ios),
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: _signUpForm(context: context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Signup in form
  Widget _signUpForm({required BuildContext context}) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sign up', style: context.textStyles.headlineLarge),
          const SizedBox(height: 30),
          GlobalTextField(
            validationMode: AutovalidateMode.onUserInteraction,
            controller: nameController,
            textInputType: TextInputType.text,
            text: 'NAME',
            fieldType: TextFormFieldType.name,
          ),
          const SizedBox(height: 20),
          GlobalTextField(
            validationMode: AutovalidateMode.onUserInteraction,
            controller: emailController,
            suffixIcon: isValidEmail ? Icon(Icons.check, size: 20) : null,
            onChanged: (val) {
              final result = Validators.validateField(
                TextFormFieldType.email,
                val,
              );

              setState(() {
                isValidEmail = result == null;
              });
            },
            textInputType: TextInputType.emailAddress,
            text: 'EMAIL',
            fieldType: TextFormFieldType.email,
          ),
          const SizedBox(height: 20),
          GlobalTextField(
            validationMode: AutovalidateMode.onUserInteraction,
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
            validationMode: AutovalidateMode.onUserInteraction,
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
            height: 50.h(context),
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
                onTap: () => context.pushNamed(
                  RouteNames.signin,
                  extra: {'has_back': true},
                ),
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
