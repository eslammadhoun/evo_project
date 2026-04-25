import 'package:evo_project/features/auth/Data/models/user_model.dart';
import 'package:evo_project/features/auth/Domain/entites/user_entity.dart';

class UserMapper {
  static UserEntity toUserEntity({required UserModel userModel}) {
    return UserEntity(
      customerToken: userModel.customerToken,
      name: userModel.name,
      email: userModel.email,
      userId: userModel.userId,
      countryCode: userModel.countryCode,
      telephone: userModel.telephone,
      newsLetter: userModel.newsLetter,
      dateOfirth: userModel.dateOfirth,
    );
  }
}
