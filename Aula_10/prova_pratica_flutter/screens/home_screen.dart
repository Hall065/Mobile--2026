// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/item.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> _itens = [];
  bool _carregando = true;

  // ─── Carrega lista do banco ───────────────────────────────
  Future<void> _carregarItens() async {
    final maps = await DatabaseHelper.instance.listarTodos();
    setState(() {
      _itens = maps.map((m) => Item.fromMap(m)).toList();
      _carregando = false;
    });
  }

  // ─── Deletar com confirmação ──────────────────────────────
  Future<void> _confirmarDelete(Item item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover item'),
        content: Text('Deseja remover "${item.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await DatabaseHelper.instance.deletar(item.id!);
      _carregarItens(); // atualiza lista
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${item.titulo}" removido.')),
        );
      }
    }
  }

  // ─── Navega para formulário (novo ou edição) ──────────────
  Future<void> _abrirFormulario({Item? item}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormScreen(item: item),
      ),
    );
    _carregarItens(); // recarrega ao voltar
  }

  @override
  void initState() {
    super.initState();
    _carregarItens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Inteligente'),
        centerTitle: false,
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _itens.isEmpty
              ? _buildEmptyState() // bônus: mensagem de vazio
              : _buildLista(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        backgroundColor: const Color(0xFF4F46E5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ─── Estado vazio (bônus) ─────────────────────────────────
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Nenhum item cadastrado',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Toque em + para adicionar o primeiro item',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ─── Lista de itens ───────────────────────────────────────
  Widget _buildLista() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _itens.length,
      itemBuilder: (context, index) {
        final item = _itens[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: () => _abrirFormulario(item: item), // editar ao tocar
            title: Text(
              item.titulo,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(item.descricao),
                if (item.data.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.data,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _confirmarDelete(item),
              tooltip: 'Remover',
            ),
          ),
        );
      },
    );
  }
}