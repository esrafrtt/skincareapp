import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:product_repository/product_repository.dart';

class FirebaseProductRepo extends ProductRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Product>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product.fromEntity(ProductEntity.fromJson(data));
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
