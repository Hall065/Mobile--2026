import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/nota.dart';

class DatabaseHelper {
  // Singleton – garante que só existe uma instância do helper
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  // ─── Banco de dados ─────────────────────────────────────────────────────────

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Caminho onde o arquivo .db será salvo no dispositivo
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'meu_diario.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notas (
        id      INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo  TEXT    NOT NULL,
        corpo   TEXT    NOT NULL,
        cor     INTEGER NOT NULL DEFAULT 0xFF6C63FF,
        criado  TEXT    NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE configuracoes (
        chave TEXT PRIMARY KEY,
        valor TEXT NOT NULL
      )
    ''');

    // Valores padrão de configuração
    await db.insert('configuracoes', {
      'chave': 'nome_usuario',
      'valor': 'Usuário',
    });
    await db.insert('configuracoes', {
      'chave': 'tema_escuro',
      'valor': '0',
    });
  }

  // ─── CRUD – Notas ────────────────────────────────────────────────────────────

  Future<int> inserirNota(Nota nota) async {
    final db = await database;
    return await db.insert('notas', nota.toMap());
  }

  Future<List<Nota>> buscarTodasNotas() async {
    final db = await database;
    final maps = await db.query('notas', orderBy: 'criado DESC');
    return maps.map((m) => Nota.fromMap(m)).toList();
  }

  Future<Nota?> buscarNotaPorId(int id) async {
    final db = await database;
    final maps = await db.query('notas', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Nota.fromMap(maps.first);
  }

  Future<int> atualizarNota(Nota nota) async {
    final db = await database;
    return await db.update(
      'notas',
      nota.toMap(),
      where: 'id = ?',
      whereArgs: [nota.id],
    );
  }

  Future<int> deletarNota(int id) async {
    final db = await database;
    return await db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> contarNotas() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as total FROM notas');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ─── CRUD – Configurações ────────────────────────────────────────────────────

  Future<String?> lerConfig(String chave) async {
    final db = await database;
    final maps = await db.query(
      'configuracoes',
      where: 'chave = ?',
      whereArgs: [chave],
    );
    if (maps.isEmpty) return null;
    return maps.first['valor'] as String?;
  }

  Future<void> salvarConfig(String chave, String valor) async {
    final db = await database;
    await db.insert(
      'configuracoes',
      {'chave': chave, 'valor': valor},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
