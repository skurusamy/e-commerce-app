import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/category_service.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService categoryService;

  CategoryBloc(this.categoryService) : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await categoryService.fetchCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError("Failed to load categories"));
      }
    });
  }
}