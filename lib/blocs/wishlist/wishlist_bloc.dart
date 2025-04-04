import 'package:flutter_bloc/flutter_bloc.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';
import '../../models/product_model.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(WishlistLoaded([])) {
    on<AddToWishlist>((event, emit) {
      if (state is WishlistLoaded) {
        final List<Product> updatedWishlist = List.from((state as WishlistLoaded).wishlist)..add(event.product);
        emit(WishlistLoaded(updatedWishlist));
      }
    });

    on<RemoveFromWishlist>((event, emit) {
      if (state is WishlistLoaded) {
        final List<Product> updatedWishlist = List.from((state as WishlistLoaded).wishlist)..remove(event.product);
        emit(WishlistLoaded(updatedWishlist));
      }
    });
  }
}
