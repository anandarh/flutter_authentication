part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState([List props = const []]);

  @override
  List<Object> get props => [];
}

/// The initial state of the LoginForm.
class LoginInitial extends LoginState {}

/// The state of the LoginForm when we are validating credentials
class LoginLoading extends LoginState {}

/// The state of the LoginForm when a login attempt has failed.
class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}