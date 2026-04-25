import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/env_config.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/router/route_paths.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/global_text_field.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              Expanded(child: _signInForm(context: context)),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  // Sigin in form
  Widget _signInForm({required BuildContext context}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: context.textStyles.headlineLarge,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Sign in to continue',
                    style: context.textStyles.bodyMedium,
                  ),
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
                          suffixIcon: isValidEmail
                              ? const Icon(Icons.check, size: 20)
                              : null,
                        ),
                        const SizedBox(height: 20),

                        GlobalTextField(
                          controller: passwordController,
                          textInputType: TextInputType.visiblePassword,
                          text: 'PASSWORD',
                          fieldType: TextFormFieldType.password,
                          obscureText: passwordObscureText,
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
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // remember me + forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (val) =>
                                setState(() => rememberMe = val ?? false),
                          ),
                          Text(
                            'Remember me',
                            style: context.textStyles.bodyMedium,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () =>
                            context.pushNamed(RouteNames.forgetPassword),
                        child: Text(
                          'Forgot password?',
                          style: context.textStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        context.go(RoutePaths.home);
                      }
                      if (state is AuthError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      return GlobalButton(
                        height: 50.h(context),
                        text: 'SIGN IN',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            print(EnvConfig.baseUrl);
                            context.read<AuthBloc>().add(
                              LoginEvent(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                          }
                        },
                        child: state is AuthLoading
                            ? const AppLoadingIndicator(
                                size: 40,
                                strokeWidth: 5,
                              )
                            : null,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account? ',
                        style: context.textStyles.bodyMedium,
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
          ),
        );
      },
    );
  }
}
