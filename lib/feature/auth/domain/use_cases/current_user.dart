import 'package:blog_app/core/error/faliures.dart';
import 'package:blog_app/core/user_case/use_case.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

//as there is not params to pass so using no params class
class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams parameter) async {
    return await authRepository.currentUser();
  }
}
