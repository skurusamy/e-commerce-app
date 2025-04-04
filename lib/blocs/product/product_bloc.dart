import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../models/product_model.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProductBloc() : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('products')
            .where('category_id', isEqualTo: event.categoryId)
            .get();

        List<Product> products = snapshot.docs
            .map((doc) => Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList();

        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError("Failed to load products"));
      }
    });
  }
}