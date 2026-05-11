class UserEntity {
  final String customerToken;
  final String name;
  final String email;
  final String userId;
  final String countryCode;
  final String telephone;
  final int newsLetter;
  final String dateOfirth;

  UserEntity({
    required this.customerToken,
    required this.name,
    required this.email,
    required this.userId,
    required this.countryCode,
    required this.telephone,
    required this.newsLetter,
    required this.dateOfirth,
  });
}
