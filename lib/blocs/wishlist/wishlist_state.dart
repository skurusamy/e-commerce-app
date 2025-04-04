import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

abstract class WishlistState extends Equatable {
  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<Product> wishlist;

  WishlistLoaded(this.wishlist);

  @override
  List<Object> get props => [wishlist];
}
