import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final String name;
  final String brand;
  final num sizeValue;
  final String sizeUnit;
  final double srp;
  final String? productImageUrl;
  final String? productDescription;
  final List<Map<String, dynamic>> prices;

  const ProductDetailsPage({
    super.key,
    required this.name,
    required this.brand,
    required this.sizeValue,
    required this.sizeUnit,
    required this.srp,
    this.productImageUrl,
    this.productDescription,
    required this.prices,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (productImageUrl != null && productImageUrl!.isNotEmpty)
                Center(
                  child: Image.network(
                    productImageUrl!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Brand: $brand',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Size: $sizeValue $sizeUnit',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'SRP: ₱${srp.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              if (productDescription != null && productDescription!.isNotEmpty)
                Text(
                  productDescription!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              const SizedBox(height: 24),
              Text(
                'Prices from stores:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...prices.map((price) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text('${price['store']} (${price['city']})'),
                      subtitle: Text('Date: ${price['date']}'),
                      trailing: Text(
                        '₱${(price['price'] as num).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add to cart or buy action
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
