import 'package:e_commerce_app/models/cart_item_model.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final CartItem cartItem;

  AddToCart(this.cartItem);
}

class RemoveFromCart extends CartEvent {
  final String productId;

  RemoveFromCart(this.productId);
}

class UpdateCartQuantity extends CartEvent {
  final String productId;
  final int quantity; // New quantity

  UpdateCartQuantity(this.productId, this.quantity);
}
