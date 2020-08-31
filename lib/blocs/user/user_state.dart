part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState([List props = const[]]);

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {
}

class UserLoading extends UserState {
}

class UserLoaded extends UserState {
  final UserModel userData;

  const UserLoaded({this.userData});

  @override
  List<Object> get props => [userData];
}

class UserFailure extends UserState {
  final String error;

  const UserFailure({this.error});

  @override
  List<Object> get props => [error];
}