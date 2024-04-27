//data layer
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/faliures.dart';
import 'package:blog_app/core/global_constant/global_constant.dart';
import 'package:blog_app/core/network/connection_check.dart';
import 'package:blog_app/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:blog_app/feature/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/common/entities/user.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  //if the method exists in our contract or not
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionCheck connectionCheck;

  const AuthRepositoryImpl(this.remoteDataSource, this.connectionCheck);

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  //signup
  @override
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionCheck.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failure('User not logged in'));
        }
        return right(UserModel(
          id: session.user.id,
          name: "",
          email: session.user.email ?? "",
        ));
      }

      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  //as some part is same for login and signup so _getUser is a separate class
  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await (connectionCheck.isConnected)) {
        return left(Failure(GlobalConstant.noConnectionMessage));
      }
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
