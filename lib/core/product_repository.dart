import 'package:pricecheck_ph/model/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products(
            id TEXT PRIMARY KEY,
            name TEXT,
            brand TEXT,
            sizeValue REAL,
            sizeUnit TEXT,
            srp REAL,
            prices TEXT
          )
        ''');
      },
    );
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final result = await db.query('products');
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product?> getProductById(String id) async {
    final db = await database;
    final result = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Product.fromJson(result.first);
    }
    return null;
  }

  Future<void> addProduct(Product product) async {
    final db = await database;
    await db.insert('products', {
      'id': product.id,
      'name': product.name,
      'brand': product.brand,
      'sizeValue': product.sizeValue,
      'sizeUnit': product.sizeUnit,
      'srp': product.srp,
      'prices': product.prices.toString(), // You may want to use jsonEncode
    });
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'products',
      {
        'name': product.name,
        'brand': product.brand,
        'sizeValue': product.sizeValue,
        'sizeUnit': product.sizeUnit,
        'srp': product.srp,
        'prices': product.prices.toString(), // You may want to use jsonEncode
      },
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
