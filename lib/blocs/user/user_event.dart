part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  UserEvent([List props = const[]]);

  @override
  List<Object> get props => [];
}

class LoadUser extends UserEvent {}

