import 'package:flutter/material.dart';
import 'home_page.dart'; // Importa a HomePage da pasta screens

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
      home: HomePage(), // Inicia a HomePage
    );
  }
}
