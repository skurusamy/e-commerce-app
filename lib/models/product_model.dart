class Product {
  final String id;
  final String name;
  final String category_id;
  final double price;
  final String imageUrl;
  final String description;

  Product({required this.id, required this.name, required this.category_id, required this.price, required this.imageUrl, required this.description});

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      category_id: data['category_id'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['image_url'] ?? '',
      description: data['description'] ?? '',
    );
  }
}