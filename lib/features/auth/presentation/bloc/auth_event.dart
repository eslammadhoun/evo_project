abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class LogoutEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String telephone;
  final String telephoneExtension;
  final String dateOfBirth;

  RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.telephone,
    required this.telephoneExtension,
    required this.dateOfBirth,
  });
}
