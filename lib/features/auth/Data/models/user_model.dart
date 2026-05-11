class UserModel {
  final String customerToken;
  final String name;
  final String email;
  final String userId;
  final String countryCode;
  final String telephone;
  final int newsLetter;
  final String dateOfirth;

  UserModel({
    required this.customerToken,
    required this.name,
    required this.email,
    required this.userId,
    required this.countryCode,
    required this.telephone,
    required this.newsLetter,
    required this.dateOfirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      customerToken: json['customer_token'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userId: json['user_id']?.toString() ?? '',
      countryCode: json['country_code'] ?? '',
      telephone: json['telephone']?.toString() ?? '',
      newsLetter: json['newsletter'] ?? 0,
      dateOfirth: json['date_of_birth'] ?? '',
    );
  }
}
