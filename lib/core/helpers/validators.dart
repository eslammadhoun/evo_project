import 'package:evo_project/core/shared/widgets/global_text_field.dart';

class Validators {
  static String? validateField(TextFormFieldType type, String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }

    switch (type) {
      case TextFormFieldType.name:
        if (value.length < 3) {
          return "Name must be at least 3 characters";
        }
        break;

      case TextFormFieldType.email:
        final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
        if (!emailRegex.hasMatch(value)) {
          return "Enter a valid email";
        }
        break;

      case TextFormFieldType.password:
        if (value.length < 6) {
          return "Password must be at least 6 characters";
        }
        break;

      case TextFormFieldType.phoneNumber:
        if (value.length < 9) {
          return "Invalid phone number";
        }
        break;
    }

    return null;
  }
}
