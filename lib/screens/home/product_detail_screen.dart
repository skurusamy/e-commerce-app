  import 'package:e_commerce_app/models/cart_item_model.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import '../../blocs/cart/cart_state.dart';
  import '../../blocs/wishlist/wishlist_bloc.dart';
  import '../../blocs/wishlist/wishlist_event.dart';
  import '../../blocs/wishlist/wishlist_state.dart';
  import '../../models/product_model.dart';
  import '../../blocs/cart/cart_bloc.dart';
  import '../../blocs/cart/cart_event.dart';
  import 'cart_screen.dart';
  
  class ProductDetailScreen extends StatelessWidget {
    final Product product;
    final String categoryName;
  
    const ProductDetailScreen({Key? key, required this.product, required this.categoryName}) : super(key: key);
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          actions: [
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
            }, icon: Icon(Icons.shopping_cart)),
            BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, state) {
                bool isWishlisted = (state is WishlistLoaded) && state.wishlist.contains(product);
  
                return IconButton(
                  icon: Icon(isWishlisted ? Icons.favorite : Icons.favorite_border, color: isWishlisted ? Colors.red : null),
                  onPressed: () {
                    if (isWishlisted) {
                      context.read<WishlistBloc>().add(RemoveFromWishlist(product));
                    } else {
                      context.read<WishlistBloc>().add(AddToWishlist(product));
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: Colors.red, size: 100),
                      ),
                    ),
  
                    // Product Info
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text("Category: ${categoryName}", style: TextStyle(fontSize: 16, color: Colors.grey)),
                          SizedBox(height: 10),
                          Text("\$${product.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                          SizedBox(height: 10),
                          Text(product.description, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
  
            // Add to Cart Button
            Padding(
              padding: EdgeInsets.all(16.0),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  int quantity = 0;
                  if (state is CartLoaded) {
                    final cartItem = state.cartItems.firstWhere(
                          (item) => item.id == product.id,
                      orElse: () => CartItem(id: product.id, name: product.name, price: product.price, imageUrl: product.imageUrl, quantity: 0),
                    );
                    quantity = cartItem.quantity;
                  }
  
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.do_disturb_on_outlined),
                        onPressed: quantity > 0
                            ? () {
                          context.read<CartBloc>().add(UpdateCartQuantity(product.id, quantity - 1));
                        }
                            : null,
                      ),
                      Text(quantity.toString(), style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline_sharp),
                        onPressed: () {
                          context.read<CartBloc>().add(UpdateCartQuantity(product.id, quantity + 1));
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          CartItem cartItem = CartItem(
                              id: product.id,
                              name: product.name,
                              price: product.price,
                              imageUrl: product.imageUrl,
                              quantity: quantity + 1);
                          context.read<CartBloc>().add(AddToCart(cartItem));
                        },
                        child: Text("Add to Cart"),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      );
    }
  }
