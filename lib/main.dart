import 'package:flutter/material.dart';
import 'package:pricecheck_ph/provider/product_provider.dart';
import 'package:pricecheck_ph/view/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => ProductProvider()..loadProducts(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PriceCheck PH',
      themeMode: ThemeMode.system,
      home: const HomePage(),
      initialRoute: '/Home',
      routes: {
        '/Home': (context) => const HomePage(),
        '/ProductDetails': (context) => const HomePage(),
        '/Favorites': (context) => const HomePage(),
      },
    );
  }
}
