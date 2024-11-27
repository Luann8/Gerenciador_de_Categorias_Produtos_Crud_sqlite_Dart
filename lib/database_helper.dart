import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('shop.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Categoria (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE Produto (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        preco REAL,
        categoria_id INTEGER,
        FOREIGN KEY(categoria_id) REFERENCES Categoria(id)
      );
    ''');
  }

  // CRUD operations for Categoria
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await instance.database;
    return await db.query('Categoria');
  }

  Future<void> insertCategory(String name) async {
    final db = await instance.database;
    await db.insert('Categoria', {'nome': name});
  }

  // CRUD operations for Produto
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await instance.database;
    return await db.query('Produto');
  }

  Future<void> insertProduct(String name, double price, int categoryId) async {
    final db = await instance.database;
    await db.insert(
        'Produto', {'nome': name, 'preco': price, 'categoria_id': categoryId});
  }

  Future<void> updateProduct(
      int id, String name, double price, int categoryId) async {
    final db = await instance.database;
    await db.update(
        'Produto', {'nome': name, 'preco': price, 'categoria_id': categoryId},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteProduct(int id) async {
    final db = await instance.database;
    await db.delete('Produto', where: 'id = ?', whereArgs: [id]);
  }
}
