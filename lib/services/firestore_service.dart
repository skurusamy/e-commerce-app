import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final firestore = FirebaseFirestore.instance;

  Future<dynamic> signUp(Map<String, dynamic> formData) async{
    try{
      final Map<String, dynamic> modifiableMap = Map.from(formData);
      modifiableMap['createdAt'] = Timestamp.now();
      await firestore.collection('users').add(modifiableMap);

    } on FirebaseAuthException catch(e){
      print('AuthService $e');
      throw Exception(e.code);
    }
  }
}