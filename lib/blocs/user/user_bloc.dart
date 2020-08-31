import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_authentication/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_authentication/models/user_model.dart';
import 'package:flutter_authentication/repositories/authentication_repository.dart';
import 'package:flutter_authentication/repositories/user_repositoriy.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthenticationBloc authBloc;

  UserBloc({@required this.authBloc}) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is LoadUser) {
      yield UserLoading();

      try {
        if (await AuthenticationRepository.isTokenExpired()) {
          authBloc.add(LoggedOut());
          yield UserInitial();
        } else {
          UserModel userData = await UserRepository.httpGetUser();
          yield UserLoaded(userData: userData);
        }
      } catch (e) {
        yield UserFailure(error: e.toString());
      }
    }
  }
}
