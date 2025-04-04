part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class HomeTabChanged extends HomeEvent {
  final int newIndex;
  const HomeTabChanged(this.newIndex);

  @override
  List<Object> get props => [newIndex];
}