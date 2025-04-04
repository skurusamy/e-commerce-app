import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userName; // Pass the logged-in user's ID

  CartBloc({required this.userName}) : super(CartInitial()) {
    _loadCartFromFirestore();

    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
  }

  // Load cart from Firestore
  Future<void> _loadCartFromFirestore() async {
    try {
      final cartSnapshot = await _firestore.collection("cart").doc(userName).collection("items").get();
      List<CartItem> cartItems = cartSnapshot.docs.map((doc) {
        var data = doc.data();
        return CartItem(
          id: doc.id,
          name: data['name'],
          price: data['price'],
          imageUrl: data['imageUrl'],
          quantity: data['quantity'],
        );
      }).toList();

      emit(CartLoaded(cartItems: cartItems));
    } catch (e) {
      emit(CartLoaded(cartItems: [])); // Default to empty cart if error occurs
    }
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final cartItems = List<CartItem>.from((state as CartLoaded).cartItems);
      final index = cartItems.indexWhere((item) => item.id == event.cartItem.id);

      if (index >= 0) {
        cartItems[index] = cartItems[index].copyWith(quantity: cartItems[index].quantity + 1);
      } else {
        cartItems.add(event.cartItem);
      }

      await _updateFirestore(cartItems);
      emit(CartLoaded(cartItems: cartItems));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final cartItems = List<CartItem>.from((state as CartLoaded).cartItems);
      cartItems.removeWhere((item) => item.id == event.productId);

      await _deleteCartItemFromFirestore(event.productId);

      emit(CartLoaded(cartItems: cartItems));
    }
  }

  void _onUpdateCartQuantity(UpdateCartQuantity event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final cartItems = List<CartItem>.from((state as CartLoaded).cartItems);
      final index = cartItems.indexWhere((item) => item.id == event.productId);

      if (index >= 0) {
        if (event.quantity > 0) {
          cartItems[index] = cartItems[index].copyWith(quantity: event.quantity);
        } else {
          await _deleteCartItemFromFirestore(event.productId);
          cartItems.removeAt(index);
        }
        await _updateFirestore(cartItems);
        emit(CartLoaded(cartItems: cartItems));
      }
      else {
        print('On plus, $index');
      }
    }
  }

  Future<void> _updateFirestore(List<CartItem> cartItems) async {
    final cartRef = _firestore.collection("cart").doc(userName).collection("items");

    for (var item in cartItems) {
      await cartRef.doc(item.id).set({
        "name": item.name,
        "price": item.price,
        "imageUrl": item.imageUrl,
        "quantity": item.quantity,
      });
    }
  }

  Future<void> _deleteCartItemFromFirestore(String productId) async {
    final cartDocRef = _firestore
        .collection('cart')
        .doc(userName)
        .collection('items')
        .doc(productId);
    await cartDocRef.delete();
  }
}
