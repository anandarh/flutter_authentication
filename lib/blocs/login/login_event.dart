part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const[]]);

  @override
  List<Object> get props => [];
}

/// LoginButtonPressed will be dispatched when a user pressed the login button.
///
/// It will notify the bloc that it needs to request a token for the given credentials.
class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'LoginButtonPressed';
}