import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

abstract class WishlistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToWishlist extends WishlistEvent {
  final Product product;

  AddToWishlist(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveFromWishlist extends WishlistEvent {
  final Product product;

  RemoveFromWishlist(this.product);

  @override
  List<Object> get props => [product];
}
