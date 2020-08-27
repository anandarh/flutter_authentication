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
  final String token;

  LoggedIn({@required this.token}) : super([token]);

  @override
  List<Object> get props => [token];
}

/// Will be dispatched on a successful logout.
///
/// It will notify the bloc that the user has successfully logged out.
class LoggedOut extends AuthenticationEvent {}