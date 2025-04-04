import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {
  final String categoryId;

  LoadProducts(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}