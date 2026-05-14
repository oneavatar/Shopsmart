class OrderModel {
  final String id;
  final List<Map<String, dynamic>> products;
  final double total;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.products,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJsonMap(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      products: List<Map<String, dynamic>>.from(json['products']),
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
