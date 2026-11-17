class CartItem {
  final String key;
  final String username;
  final int productId;
  final String title;
  final double price;
  final String image;
  int quantity;
  final int stock;
  final String category;

  CartItem({
    required this.key,
    required this.username,
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
    required this.stock,
    required this.category,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'username': username,
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
      'stock': stock,
      'category': category,
    };
  }

  factory CartItem.fromMap(String key, Map<dynamic, dynamic> map) {
    return CartItem(
      key: key,
      username: map['username']?.toString() ?? '',
      productId: (map['productId'] as num?)?.toInt() ?? 0,
      title: map['title']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      image: map['image']?.toString() ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      category: map['category']?.toString() ?? '',
    );
  }
}
