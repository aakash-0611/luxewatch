class Order {
  final int id;
  final double total;
  final String status;
  final DateTime createdAt;

  // Items OPTIONAL (not returned by /orders)
  final List<dynamic> items;

  Order({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
    this.items = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      total: double.parse(json['total'].toString()),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      items: json['items'] ?? [],
    );
  }
}
