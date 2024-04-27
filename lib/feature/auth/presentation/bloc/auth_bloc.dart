import 'dart:async';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/user_case/use_case.dart';
import 'package:blog_app/feature/auth/domain/use_cases/current_user.dart';
import 'package:blog_app/feature/auth/domain/use_cases/user_login.dart';
import 'package:blog_app/feature/auth/domain/use_cases/user_sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/entities/user.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    //this will make ensure that whenever the event is triggered then show loading
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  //signup
  FutureOr<void> _onAuthSignUp(
      AuthSignUp event, Emitter<AuthState> emit) async {
    // emit(AuthLoading()); // as we have declared on top for loading
    //userSignUp.call() = similar to userSignUp()
    final response = await _userSignUp(UserSignUpParameter(
      name: event.name,
      email: event.email,
      password: event.password,
    ));

    //l -> failure r -> success
    response.fold(
      (l) => emit(AuthFailure(l.message)),
      // (r) => emit(AuthSuccess(r)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  //login
  FutureOr<void> _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    // emit(AuthLoading()); // as we have declared on top for loading
    final response = await _userLogin(
        UserLoginParameter(email: event.email, password: event.password));

    //l -> failure r -> success
    response.fold(
      (l) => emit(AuthFailure(l.message)),
      // (r) => emit(AuthSuccess(r)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  FutureOr<void> _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      // (r) => emit(AuthSuccess(r)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  //private fun for updating the user
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
