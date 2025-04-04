import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(currentIndex: 0)) {
    on<HomeTabChanged>((event, emit) {
      emit(HomeState(currentIndex: event.newIndex));
    });
  }
}