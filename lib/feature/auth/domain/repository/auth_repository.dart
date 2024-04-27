//domain layer
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/faliures.dart';
import '../../../../core/common/entities/user.dart';

abstract interface class AuthRepository {
  //sign up method
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name, required String email, required String password});

//login method
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password});

  //get current user
  Future<Either<Failure, User>> currentUser();
}
