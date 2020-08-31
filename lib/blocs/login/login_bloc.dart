import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_authentication/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_authentication/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository authRepository;
  final AuthenticationBloc authBloc;

  LoginBloc({
    @required this.authRepository,
    @required this.authBloc,
  })  : assert(authRepository != null),
        assert(authBloc != null), super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final tokens = await authRepository.authenticate(
          email: event.email,
          password: event.password,
        );

        authBloc.add(LoggedIn(tokens: tokens));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
