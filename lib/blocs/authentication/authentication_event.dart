part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

/// Will be dispatched when the Flutter application first loads.
///
/// It will notify bloc that it needs to determine whether or not there is an existing user.
class AppStarted extends AuthenticationEvent {}

/// Will be dispatched on a successful login.
///
/// It will notify the bloc that the user has successfully logged in.
class LoggedIn extends AuthenticationEvent {
  final AuthenticationModel tokens;

  LoggedIn({@required this.tokens}) : super([tokens]);

  @override
  List<Object> get props => [tokens];
}

/// Will be dispatched on a successful logout.
///
/// It will notify the bloc that the user has successfully logged out.
class LoggedOut extends AuthenticationEvent {}