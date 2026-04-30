import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/global_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool passwordObscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Spacing.appPadding,
          child: Column(
            children: [
              HeaderWidget(
                firstWidget: FirstWidget.back,
                midWidget: MidWidget.text,
                lastWidget: LastWidget.nothing,
                text: 'Reset password',
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
              'Enter new password and confirm.',
              style: context.textStyles.bodyMedium,
            ),
          ),
          const SizedBox(height: 40),
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
            text: 'NEW PASSWORD',
            fieldType: TextFormFieldType.password,
          ),
          const SizedBox(height: 20),
          GlobalTextField(
            validationMode: AutovalidateMode.onUserInteraction,
            controller: confirmPasswordController,
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
            validator: (val) {
              return confirmPasswordController.text != passwordController.text
                  ? 'Please Use The Same Password'
                  : null;
            },
          ),
          const SizedBox(height: 20),
          GlobalButton(
            text: 'SEND',
            onTap: () => _formKey.currentState!.validate()
                ? context.goNamed(
                    RouteNames.succesPage,
                    extra: {
                      'title': 'Your password has\nbeen reset!',
                      'subTitle':
                          'Qui ex aute ipsum duis.\nIncididunt adipisicing voluptate laborum',
                      'iconPath': 'key_icon',
                      'buttonText': 'DONE',
                      'destination': 'signIn',
                    },
                  )
                : null,
            height: 50.h(context),
          ),
        ],
      ),
    );
  }
}
