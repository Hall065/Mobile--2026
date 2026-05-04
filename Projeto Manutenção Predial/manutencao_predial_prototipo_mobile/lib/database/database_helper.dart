import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/chamado.dart';
import '../models/agendamento.dart';
import '../models/estoque_item.dart';
import '../models/usuario.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('manutencao_predial.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email_cpf TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE chamados (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        local TEXT NOT NULL,
        status TEXT NOT NULL,
        tipo TEXT NOT NULL,
        prioridade TEXT NOT NULL,
        descricao TEXT,
        responsavel TEXT,
        data_abertura TEXT NOT NULL,
        data_atualizacao TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE agendamentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        local TEXT NOT NULL,
        horario TEXT NOT NULL,
        data TEXT NOT NULL,
        tipo TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE estoque (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        categoria TEXT NOT NULL,
        quantidade REAL NOT NULL,
        unidade TEXT NOT NULL,
        quantidade_minima REAL NOT NULL,
        localizacao TEXT,
        updated_at TEXT NOT NULL
      )
    ''');
    await _seed(db);
  }

  Future<void> _seed(Database db) async {
    final hoje = DateTime.now();
    final dataHoje =
        '${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';
    final now = hoje.toIso8601String();

    // Seed chamados
    final chamados = [
      {'titulo': 'Inspeção Elétrica', 'local': 'Bloco A - Sala 23', 'status': 'Em Andamento', 'tipo': 'Preventiva', 'prioridade': 'Alta', 'descricao': 'Inspeção geral do sistema elétrico do bloco A.', 'responsavel': 'Carlos Silva', 'data_abertura': hoje.subtract(const Duration(days: 2)).toIso8601String(), 'data_atualizacao': now},
      {'titulo': 'Vazamento Hidráulico', 'local': 'Bloco C - Banheiro 1', 'status': 'Pendente', 'tipo': 'Corretiva', 'prioridade': 'Alta', 'descricao': 'Vazamento na tubulação do banheiro masculino.', 'responsavel': 'Maria Santos', 'data_abertura': hoje.subtract(const Duration(days: 1)).toIso8601String(), 'data_atualizacao': now},
      {'titulo': 'Troca de Lâmpadas', 'local': 'Bloco B - Corredor', 'status': 'Em Andamento', 'tipo': 'Corretiva', 'prioridade': 'Baixa', 'descricao': 'Troca de 12 lâmpadas queimadas no corredor principal.', 'responsavel': 'João Pereira', 'data_abertura': hoje.subtract(const Duration(days: 3)).toIso8601String(), 'data_atualizacao': now},
      {'titulo': 'Manutenção AC Sala 301', 'local': 'Bloco D - Sala 301', 'status': 'Concluído', 'tipo': 'Preventiva', 'prioridade': 'Média', 'descricao': 'Limpeza e revisão do ar-condicionado.', 'responsavel': 'Carlos Silva', 'data_abertura': hoje.subtract(const Duration(days: 5)).toIso8601String(), 'data_atualizacao': hoje.subtract(const Duration(days: 1)).toIso8601String()},
      {'titulo': 'Conserto de Janela', 'local': 'Bloco A - Sala 12', 'status': 'Pendente', 'tipo': 'Corretiva', 'prioridade': 'Média', 'descricao': 'Janela com fechadura quebrada.', 'responsavel': 'Maria Santos', 'data_abertura': hoje.subtract(const Duration(days: 1)).toIso8601String(), 'data_atualizacao': now},
      {'titulo': 'Inspeção Mausoleu', 'local': 'Área Externa', 'status': 'Em Andamento', 'tipo': 'Preventiva', 'prioridade': 'Baixa', 'descricao': 'Inspeção estrutural semestral.', 'responsavel': 'João Pereira', 'data_abertura': hoje.subtract(const Duration(days: 4)).toIso8601String(), 'data_atualizacao': now},
      {'titulo': 'Curto Elétrico Bloco E', 'local': 'Bloco E - Sala 22', 'status': 'Alerta', 'tipo': 'Corretiva', 'prioridade': 'Alta', 'descricao': 'Curto no quadro de distribuição elétrica.', 'responsavel': 'Carlos Silva', 'data_abertura': hoje.toIso8601String(), 'data_atualizacao': now},
      {'titulo': 'Pintura Corredor Principal', 'local': 'Bloco A - Corredor', 'status': 'Pendente', 'tipo': 'Preventiva', 'prioridade': 'Baixa', 'descricao': 'Repintura das paredes do corredor principal.', 'responsavel': 'Maria Santos', 'data_abertura': hoje.subtract(const Duration(days: 6)).toIso8601String(), 'data_atualizacao': now},
    ];
    for (final c in chamados) {
      await db.insert('chamados', c);
    }

    // Seed agendamentos para hoje
    final agendamentos = [
      {'titulo': 'Inspeção Elétrica', 'local': 'Sala 23', 'horario': '10:00', 'data': dataHoje, 'tipo': 'Preventiva'},
      {'titulo': 'Inspeção Mausoleu', 'local': 'Sala 22', 'horario': '12:00', 'data': dataHoje, 'tipo': 'Preventiva'},
      {'titulo': 'Troca Lâmpada', 'local': 'Sala 23', 'horario': '14:00', 'data': dataHoje, 'tipo': 'Corretiva'},
      {'titulo': 'Conserto Janela', 'local': 'Sala 23', 'horario': '16:00', 'data': dataHoje, 'tipo': 'Corretiva'},
    ];
    for (final a in agendamentos) {
      await db.insert('agendamentos', a);
    }

    // Seed estoque
    final estoque = [
      {'nome': 'Lâmpada LED 40W', 'categoria': 'Elétrico', 'quantidade': 50.0, 'unidade': 'un', 'quantidade_minima': 10.0, 'localizacao': 'Almoxarifado A', 'updated_at': now},
      {'nome': 'Disjuntor 20A', 'categoria': 'Elétrico', 'quantidade': 8.0, 'unidade': 'un', 'quantidade_minima': 5.0, 'localizacao': 'Almoxarifado A', 'updated_at': now},
      {'nome': 'Cabo Elétrico 2,5mm', 'categoria': 'Elétrico', 'quantidade': 200.0, 'unidade': 'm', 'quantidade_minima': 50.0, 'localizacao': 'Almoxarifado B', 'updated_at': now},
      {'nome': 'Torneira Inox', 'categoria': 'Hidráulico', 'quantidade': 3.0, 'unidade': 'un', 'quantidade_minima': 5.0, 'localizacao': 'Almoxarifado B', 'updated_at': now},
      {'nome': 'Cano PVC 50mm', 'categoria': 'Hidráulico', 'quantidade': 25.0, 'unidade': 'm', 'quantidade_minima': 10.0, 'localizacao': 'Almoxarifado B', 'updated_at': now},
      {'nome': 'Tinta Acrílica Branca', 'categoria': 'Pintura', 'quantidade': 4.0, 'unidade': 'galão', 'quantidade_minima': 2.0, 'localizacao': 'Almoxarifado C', 'updated_at': now},
      {'nome': 'Parafuso M6 Sextavado', 'categoria': 'Ferragem', 'quantidade': 500.0, 'unidade': 'un', 'quantidade_minima': 100.0, 'localizacao': 'Almoxarifado A', 'updated_at': now},
      {'nome': 'Fita Isolante 19mm', 'categoria': 'Elétrico', 'quantidade': 2.0, 'unidade': 'rolo', 'quantidade_minima': 5.0, 'localizacao': 'Almoxarifado A', 'updated_at': now},
    ];
    for (final e in estoque) {
      await db.insert('estoque', e);
    }
  }

  // ─── CHAMADOS ──────────────────────────────────────────────────────────────

  Future<int> insertChamado(Chamado c) async =>
      (await database).insert('chamados', c.toMap());

  Future<List<Chamado>> getChamados({String? status, String? tipo, String? prioridade, String? local}) async {
    final db = await database;
    final where = <String>[];
    final args = <String>[];
    if (status != null && status.isNotEmpty) { where.add('status = ?'); args.add(status); }
    if (tipo != null && tipo.isNotEmpty) { where.add('tipo = ?'); args.add(tipo); }
    if (prioridade != null && prioridade.isNotEmpty) { where.add('prioridade = ?'); args.add(prioridade); }
    if (local != null && local.isNotEmpty) { where.add('local LIKE ?'); args.add('%$local%'); }
    final rows = await db.query('chamados',
        where: where.isEmpty ? null : where.join(' AND '),
        whereArgs: args.isEmpty ? null : args,
        orderBy: 'data_atualizacao DESC');
    return rows.map(Chamado.fromMap).toList();
  }

  Future<Map<String, int>> getChamadosStats() async {
    final db = await database;
    final rows = await db.rawQuery('SELECT status, COUNT(*) as cnt FROM chamados GROUP BY status');
    return {for (final r in rows) r['status'] as String: r['cnt'] as int};
  }

  Future<Map<String, int>> getTiposStats() async {
    final db = await database;
    final rows = await db.rawQuery('SELECT tipo, COUNT(*) as cnt FROM chamados GROUP BY tipo');
    return {for (final r in rows) r['tipo'] as String: r['cnt'] as int};
  }

  Future<int> updateChamado(Chamado c) async =>
      (await database).update('chamados', c.toMap(), where: 'id = ?', whereArgs: [c.id]);

  Future<int> deleteChamado(int id) async =>
      (await database).delete('chamados', where: 'id = ?', whereArgs: [id]);

  // ─── AGENDAMENTOS ──────────────────────────────────────────────────────────

  Future<int> insertAgendamento(Agendamento a) async =>
      (await database).insert('agendamentos', a.toMap());

  Future<List<Agendamento>> getAgendamentosHoje() async {
    final db = await database;
    final hoje = DateTime.now();
    final dataStr =
        '${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';
    final rows = await db.query('agendamentos',
        where: 'data = ?', whereArgs: [dataStr], orderBy: 'horario ASC');
    return rows.map(Agendamento.fromMap).toList();
  }

  Future<int> deleteAgendamento(int id) async =>
      (await database).delete('agendamentos', where: 'id = ?', whereArgs: [id]);

  // ─── ESTOQUE ───────────────────────────────────────────────────────────────

  Future<int> insertEstoqueItem(EstoqueItem item) async =>
      (await database).insert('estoque', item.toMap());

  Future<List<EstoqueItem>> getEstoque() async {
    final rows = await (await database).query('estoque', orderBy: 'nome ASC');
    return rows.map(EstoqueItem.fromMap).toList();
  }

  Future<int> updateEstoqueItem(EstoqueItem item) async =>
      (await database).update('estoque', item.toMap(), where: 'id = ?', whereArgs: [item.id]);

  Future<int> deleteEstoqueItem(int id) async =>
      (await database).delete('estoque', where: 'id = ?', whereArgs: [id]);

  // ─── USUÁRIOS ──────────────────────────────────────────────────────────────

  Future<int> insertUsuario(Usuario u) async =>
      (await database).insert('usuarios', u.toMap());

  Future<Usuario?> login(String emailCpf, String senha) async {
    final db = await database;
    final rows = await db.query('usuarios',
        where: 'email_cpf = ? AND senha = ?', whereArgs: [emailCpf, senha]);
    if (rows.isEmpty) return null;
    return Usuario.fromMap(rows.first);
  }

  Future<bool> emailExists(String emailCpf) async {
    final db = await database;
    final rows = await db.query('usuarios',
        where: 'email_cpf = ?', whereArgs: [emailCpf]);
    return rows.isNotEmpty;
  }
}
