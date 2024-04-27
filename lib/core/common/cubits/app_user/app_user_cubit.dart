import 'package:blog_app/core/common/entities/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      print("no user");
      emit(AppUserInitial());
    } else {
      print("user available");
      emit(AppUserLoggedIn(user));
    }
  }
}
