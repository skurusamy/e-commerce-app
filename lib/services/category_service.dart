import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> fetchCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) =>
          Category.fromFirestore(doc.data() as Map<String, dynamic>)
      ).toList();
    } catch (e) {
      throw Exception("Error fetching categories: $e");
    }
  }
}