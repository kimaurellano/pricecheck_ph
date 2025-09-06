class Product {
  final String id;
  final String name;
  final String brand;
  final num sizeValue;
  final String sizeUnit;
  final double srp;
  final List<dynamic> prices;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.sizeValue,
    required this.sizeUnit,
    required this.srp,
    required this.prices,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        brand: json['brand'],
        sizeValue: json['sizeValue'],
        sizeUnit: json['sizeUnit'],
        srp: (json['srp'] as num).toDouble(),
        prices: json['prices'],
      );
}
