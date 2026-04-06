import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/nota.dart';
import 'detalhes_screen.dart';
import 'nova_nota_screen.dart';
import 'perfil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _db = DatabaseHelper.instance;
  List<Nota> _notas = [];
  String _nomeUsuario = 'Usuário';
  bool _carregando = true;

  // Paleta de cores para as notas
  static const List<int> _coresDisponiveis = [
    0xFF6C63FF, // lilás
    0xFF43C6AC, // verde água
    0xFFFF6584, // rosa
    0xFFFFBE76, // amarelo
    0xFF74B9FF, // azul claro
    0xFFA29BFE, // roxo claro
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final notas = await _db.buscarTodasNotas();
    final nome = await _db.lerConfig('nome_usuario') ?? 'Usuário';
    setState(() {
      _notas = notas;
      _nomeUsuario = nome;
      _carregando = false;
    });
  }

  Future<void> _deletarNota(int id) async {
    await _db.deletarNota(id);
    await _carregarDados();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nota excluída'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, $_nomeUsuario 👋',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const Text(
              'Meu Diário',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Perfil',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PerfilScreen()),
              );
              _carregarDados();
            },
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _notas.isEmpty
              ? _telaVazia()
              : _listaNotes(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NovaNoteScreen(
                coresDisponiveis: _coresDisponiveis,
              ),
            ),
          );
          _carregarDados();
        },
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova nota'),
      ),
    );
  }

  Widget _telaVazia() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.note_add_outlined, size: 72, color: Color(0xFFBDBDBD)),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma nota ainda',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toque em "Nova nota" para começar!',
            style: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
          ),
        ],
      ),
    );
  }

  Widget _listaNotes() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _notas.length,
      itemBuilder: (context, index) {
        final nota = _notas[index];
        final cor = Color(nota.cor);
        return Dismissible(
          key: Key('nota_${nota.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
          ),
          onDismissed: (_) => _deletarNota(nota.id!),
          child: GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalhesScreen(
                    nota: nota,
                    coresDisponiveis: _coresDisponiveis,
                  ),
                ),
              );
              _carregarDados();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: cor.withAlpha(30),
                border: Border.all(color: cor.withAlpha(80)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: cor.withAlpha(60),
                  child: Icon(Icons.note_alt_outlined, color: cor, size: 22),
                ),
                title: Text(
                  nota.titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cor.withAlpha(230),
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      nota.corpo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF616161),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatarData(nota.criado),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: cor.withAlpha(150),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatarData(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}
