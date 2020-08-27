part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]);

  @override
  List<Object> get props => [];
}

/// Waiting to see if the user is authenticated or not on app start.
///
/// If the authentication state was uninitialized, the user might be seeing a splash screen.
class AuthenticationInitial extends AuthenticationState {}

/// Waiting to persist/delete a token
///
/// If the authentication state was loading, the user might be seeing a progress indicator.
class AuthenticationLoading extends AuthenticationState {}

/// Successfully authenticated
///
/// If the authentication state was authenticated, the user might see a home screen.
class AuthenticationAuthenticated extends AuthenticationState {}
/// Not authenticated
///
/// If the authentication state was unauthenticated, the user might see a login form.
class AuthenticationUnauthenticated extends AuthenticationState {}