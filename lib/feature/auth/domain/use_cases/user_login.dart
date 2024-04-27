import 'package:blog_app/core/error/faliures.dart';
import 'package:blog_app/core/user_case/use_case.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<User, UserLoginParameter> {
  final AuthRepository authRepository;

  const UserLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParameter parameter) async {
    return await authRepository.loginWithEmailPassword(
      email: parameter.email,
      password: parameter.password,
    );
  }
}

class UserLoginParameter {
  final String email;
  final String password;

  UserLoginParameter({required this.email, required this.password});
}
