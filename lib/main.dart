import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD com Relacionamento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Database? _database;
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'shop.db');
    _database = await openDatabase(path, version: 1, onCreate: (db, version) async {
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
    });
    _loadData();
  }

  Future<void> _loadData() async {
    final categories = await _database!.query('Categoria');
    final products = await _database!.query('Produto');

    setState(() {
      _categories = categories;
      _products = products;
    });
  }

  Future<void> _addCategory(String name) async {
    await _database!.insert('Categoria', {'nome': name});
    _loadData();
  }

  Future<void> _addProduct(String name, double price, int categoryId) async {
    await _database!.insert('Produto', {'nome': name, 'preco': price, 'categoria_id': categoryId});
    _loadData();
  }

  Future<void> _updateProduct(int id, String name, double price, int categoryId) async {
    await _database!.update('Produto', {'nome': name, 'preco': price, 'categoria_id': categoryId}, where: 'id = ?', whereArgs: [id]);
    _loadData();
  }

  Future<void> _deleteProduct(int id) async {
    await _database!.delete('Produto', where: 'id = ?', whereArgs: [id]);
    _loadData();
  }

  _showProductForm({int? id, String? currentName, double? currentPrice, int? currentCategoryId, required BuildContext context}) {
    final nameController = TextEditingController(text: currentName);
    final priceController = TextEditingController(text: currentPrice?.toString());
    int? selectedCategoryId = currentCategoryId;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(id == null ? 'Novo Produto' : 'Editar Produto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nome do Produto'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Preço'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  decoration: InputDecoration(labelText: 'Categoria'),
                  items: _categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(category['nome']),
                    );
                  }).toList()
                    ..add(
                      DropdownMenuItem<int>(
                        value: null,
                        child: Text('Nova Categoria...'),
                      ),
                    ),
                  onChanged: (value) async {
                    if (value == null) {
                      final newCategoryNameController = TextEditingController();
                      await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Nova Categoria'),
                          content: TextField(
                            controller: newCategoryNameController,
                            decoration: InputDecoration(labelText: 'Nome da Categoria'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                final name = newCategoryNameController.text;
                                if (name.isNotEmpty) {
                                  _addCategory(name);
                                }
                                Navigator.pop(context);
                              },
                              child: Text('Salvar'),
                            ),
                          ],
                        ),
                      );
                      _loadData();
                      setState(() {
                        selectedCategoryId = _categories.last['id'];
                      });
                    } else {
                      setState(() {
                        selectedCategoryId = value;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final name = nameController.text;
                  final price = double.parse(priceController.text);
                  if (id == null) {
                    _addProduct(name, price, selectedCategoryId!);
                  } else {
                    _updateProduct(id, name, price, selectedCategoryId!);
                  }
                  Navigator.pop(context);
                },
                child: Text('Salvar'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<int, List<Map<String, dynamic>>> productsByCategory = {};
    for (var product in _products) {
      int categoryId = product['categoria_id'];
      if (productsByCategory[categoryId] == null) {
        productsByCategory[categoryId] = [];
      }
      productsByCategory[categoryId]!.add(product);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Categorias e Produtos'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          ListTile(
            title: Text('Categorias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: Icon(Icons.add, color: Colors.blue),
              onPressed: () => _showProductForm(context: context),
            ),
          ),
          ..._categories.map((category) {
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(category['nome'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('ID: ${category['id']}'),
                  ),
                  Divider(),
                  ...?productsByCategory[category['id']]?.map((product) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                      child: ListTile(
                        leading: Icon(Icons.shopping_cart, color: Colors.blue),
                        title: Text('${product['nome']} - R\$ ${product['preco']}'),
                        subtitle: Text('ID do Produto: ${product['id']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _showProductForm(
                                id: product['id'],
                                currentName: product['nome'],
                                currentPrice: product['preco'],
                                currentCategoryId: product['categoria_id'],
                                context: context,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteProduct(product['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList() ?? [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text('Nenhum produto', style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
