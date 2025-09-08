import 'package:flutter/material.dart';
import 'package:pricecheck_ph/provider/product_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().products;
    final filteredItems = products
        .where((item) =>
            item.name.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'admin') {
                Navigator.pushNamed(context, '/Admin');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'admin',
                child: Text('Admin'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredItems[index].name),
                  subtitle: Text(filteredItems[index].brand),
                  trailing:
                      Text('₱${filteredItems[index].srp.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.pushNamed(context, '/ProductDetails',
                        arguments: filteredItems[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
