import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/validators.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/router/route_paths.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/global_text_field.dart';
import 'package:evo_project/core/services/snack_service.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';

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
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  String selectedCountryCode = '966';

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
                            child: BlocConsumer<AuthBloc, AuthState>(
                              listener: (context, state) {
                                if (state is AuthSuccess) {
                                  context.go(RoutePaths.home);
                                } else if (state is AuthError) {
                                  SnackService.show(state.message);
                                }
                              },
                              builder: (context, state) {
                                return _signUpForm(
                                  context: context,
                                  isLoading: state is AuthLoading,
                                );
                              },
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
    );
  }

  // Signup in form
  Widget _signUpForm({required BuildContext context, bool isLoading = false}) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(primaryColor: context.colors.primary),
                      child: CountryPickerDialog(
                        titlePadding: const EdgeInsets.all(8.0),
                        searchCursorColor: context.colors.primary,
                        searchInputDecoration: const InputDecoration(
                          hintText: 'Search...',
                        ),
                        isSearchable: true,
                        itemFilter: (Country country) =>
                            ['AE', 'SA'].contains(country.isoCode),
                        title: Text(
                          'Select your phone code',
                          style: context.textStyles.titleLarge,
                        ),
                        onValuePicked: (Country country) {
                          setState(() {
                            selectedCountryCode = country.phoneCode;
                          });
                        },
                        itemBuilder: (Country country) => Row(
                          children: <Widget>[
                            CountryPickerUtils.getDefaultFlagImage(country),
                            const SizedBox(width: 8.0),
                            Text("+${country.phoneCode}"),
                            const SizedBox(width: 8.0),
                            Flexible(child: Text(country.name)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50.h(context),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.colors.outline),
                  ),
                  child: Center(
                    child: Text(
                      '+$selectedCountryCode',
                      style: context.textStyles.bodyLarge,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GlobalTextField(
                  validationMode: AutovalidateMode.onUserInteraction,
                  controller: phoneController,
                  textInputType: TextInputType.phone,
                  text: 'PHONE NUMBER',
                  fieldType: TextFormFieldType
                      .name, // Using name type for custom label or just generic text
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GlobalTextField(
            readOnly: true,
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  dateOfBirthController.text = pickedDate.toString().split(
                    ' ',
                  )[0];
                });
              }
            },
            validationMode: AutovalidateMode.onUserInteraction,
            controller: dateOfBirthController,
            textInputType: TextInputType.datetime,
            text: 'DATE OF BIRTH',
            fieldType: TextFormFieldType.name,
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
            onTap: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  RegisterEvent(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    telephone: phoneController.text,
                    telephoneExtension: selectedCountryCode,
                    dateOfBirth: dateOfBirthController.text,
                  ),
                );
              }
            },
            height: 50.h(context),
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text('SIGN UP', style: TextStyle(color: Colors.white)),
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
