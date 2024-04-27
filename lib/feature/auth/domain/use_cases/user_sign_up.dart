import 'package:blog_app/core/error/faliures.dart';
import 'package:blog_app/core/user_case/use_case.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';

class UserSignUp implements UseCase<User, UserSignUpParameter> {
  final AuthRepository authRepository;

  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParameter parameter) async {
    return await authRepository.signUpWithEmailPassword(
      name: parameter.name,
      email: parameter.email,
      password: parameter.password,
    );
  }
}

//below class is for getting name,email,password
//because we cannot pass directly those 3
class UserSignUpParameter {
  final String name;
  final String email;
  final String password;

  UserSignUpParameter({
    required this.name,
    required this.email,
    required this.password,
  });
}
