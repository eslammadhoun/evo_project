import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/validators.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/global_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();
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
            children: [
              HeaderWidget(
                firstWidget: FirstWidget.back,
                midWidget: MidWidget.text,
                lastWidget: LastWidget.nothing,
                text: 'Forgot password',
              ),
              const SizedBox(height: 25),
              _body(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body({required BuildContext context}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Text(
              'Please enter your email address. You will\nreceive a link to create a new password via\nemail.',
              style: context.textStyles.bodyMedium,
            ),
          ),
          const SizedBox(height: 40),
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
          GlobalButton(
            text: 'SEND',
            onTap: () => _formKey.currentState!.validate()
                ? context.pushNamed(RouteNames.newPassword)
                : null,
          ),
        ],
      ),
    );
  }
}
