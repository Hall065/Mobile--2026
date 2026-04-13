// lib/helpers/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cadastro.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabela obrigatória + campo bônus "data"
    await db.execute('''
      CREATE TABLE dados (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo    TEXT    NOT NULL,
        descricao TEXT,
        data      TEXT
      )
    ''');
  }

  // ─── CREATE ──────────────────────────────────────────────
  Future<int> inserir(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('dados', item);
  }

  // ─── READ (bônus: ordenado por título) ───────────────────
  Future<List<Map<String, dynamic>>> listarTodos() async {
    final db = await database;
    return await db.query('dados', orderBy: 'titulo ASC');
  }

  // ─── UPDATE ──────────────────────────────────────────────
  Future<int> atualizar(Map<String, dynamic> item) async {
    final db = await database;
    return await db.update(
      'dados',
      item,
      where: 'id = ?',
      whereArgs: [item['id']],
    );
  }

  // ─── DELETE ──────────────────────────────────────────────
  Future<int> deletar(int id) async {
    final db = await database;
    return await db.delete(
      'dados',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}