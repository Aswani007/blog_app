//creating this abstract class so that we don't miss out with any implementation

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/feature/auth/data/models/user_model.dart';
import 'package:logger/web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  //sign up remote
  Future<UserModel> signUpWithEmailPassword(
      {required String name, required String email, required String password});
  //login remote
  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password});

  Future<UserModel?> getCurrentUserData();
}

//auth remote implementation
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  //get user session
  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  //login
  @override
  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      //hit supabase login user
      final response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);

      Logger().i(response);

      //check whether the user is null or not
      if (response.user == null) {
        throw ServerException("User Is Null!");
      }

      // user exist then return user id
      return UserModel.fromJson(response.user!.toJson())
          .copyWith(email: currentUserSession!.user.email);
    } on AuthException catch (e) {
      throw ServerException(e.message);
      // return left(Failure(e.message));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  //sign up
  @override
  Future<UserModel> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      //hit supabase signup user
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {'name': name});

      //check whether the user is null or not
      if (response.user == null) {
        throw ServerException("User Is Null!");
      }

      // user exist then return user id
      return UserModel.fromJson(response.user!.toJson())
          .copyWith(email: currentUserSession!.user.email);
    } on AuthException catch (e) {
      throw ServerException(e.message);
      // return left(Failure(e.message));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  //get current user
  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        //getting all the data(column) from profiles table
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(userData.first)
            .copyWith(email: currentUserSession!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
