import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/global_text_field.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core
import 'package:evo_project/core/router/route_paths.dart';

// Bloc
import 'package:evo_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_state.dart';

class SigninPage extends StatefulWidget {
  final bool hasBack;
  const SigninPage({super.key, required this.hasBack});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
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
                        if (widget.hasBack)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _BackButton(),
                          ),

                        Expanded(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _Header(),
                                  const SizedBox(height: 30),

                                  _FormSection(
                                    formKey: _formKey,
                                    emailController: emailController,
                                    passwordController: passwordController,
                                    obscurePassword: obscurePassword,
                                    onTogglePassword: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  _RememberForgot(
                                    rememberMe: rememberMe,
                                    onRememberChanged: (val) {
                                      setState(() => rememberMe = val);
                                    },
                                  ),

                                  const SizedBox(height: 32),

                                  _LoginButton(onTap: _onLogin),

                                  const SizedBox(height: 20),

                                  _SignupRow(),
                                ],
                              ),
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
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome Back!', style: context.textStyles.headlineLarge),
        const SizedBox(height: 14),
        Text('Sign in to continue', style: context.textStyles.bodyMedium),
      ],
    );
  }
}

class _FormSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const _FormSection({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          GlobalTextField(
            controller: emailController,
            text: 'EMAIL',
            textInputType: TextInputType.emailAddress,
            fieldType: TextFormFieldType.email,
            validationMode: AutovalidateMode.onUserInteraction,
          ),

          const SizedBox(height: 20),

          GlobalTextField(
            controller: passwordController,
            text: 'PASSWORD',
            fieldType: TextFormFieldType.password,
            obscureText: obscurePassword,
            validationMode: AutovalidateMode.onUserInteraction,
            textInputType: TextInputType.text,
            suffixIcon: InkWell(
              onTap: onTogglePassword,
              child: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RememberForgot extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;

  const _RememberForgot({
    required this.rememberMe,
    required this.onRememberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (val) => onRememberChanged(val ?? false),
            ),
            Text('Remember me', style: context.textStyles.bodyMedium),
          ],
        ),
        InkWell(
          onTap: () => context.pushNamed(RouteNames.forgetPassword),
          child: Text('Forgot password?', style: context.textStyles.bodyMedium),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LoginButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, curr) => curr is AuthLoading || prev is AuthLoading,
      builder: (context, state) {
        return GlobalButton(
          text: 'SIGN IN',
          height: 50,
          onTap: state is AuthLoading ? null : onTap,
          child: state is AuthLoading
              ? const AppLoadingIndicator(size: 30, strokeWidth: 4)
              : null,
        );
      },
    );
  }
}

class _SignupRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Don’t have an account? ', style: context.textStyles.bodyMedium),
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
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(),
      child: const Icon(Icons.arrow_back_ios),
    );
  }
}
