import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/item.dart';

class FormScreen extends StatefulWidget {
  final Item? item;

  const FormScreen({super.key, this.item});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloCtrl;
  late TextEditingController _descricaoCtrl;

  bool get _editando => widget.item != null;

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController(text: widget.item?.titulo ?? '');
    _descricaoCtrl = TextEditingController(text: widget.item?.descricao ?? '');
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    super.dispose();
  }

  String _dataAtual() {
    final now = DateTime.now();
    return '${now.year}-${_pad(now.month)}-${_pad(now.day)} '
        '${_pad(now.hour)}:${_pad(now.minute)}';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final novoItem = Item(
      id: widget.item?.id,
      titulo: _tituloCtrl.text.trim(),
      descricao: _descricaoCtrl.text.trim(),
      data: _editando ? widget.item!.data : _dataAtual(),
    );

    if (_editando) {
      await DatabaseHelper.instance.atualizar(novoItem.toMap());
    } else {
      await DatabaseHelper.instance.inserir(novoItem.toMap());
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editando ? 'Item atualizado!' : 'Item cadastrado!'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Item' : 'Novo Item'),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloCtrl,
                decoration: _inputDecoration('Titulo', Icons.label_outline),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Informe o titulo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoCtrl,
                decoration:
                    _inputDecoration('Descricao', Icons.notes_outlined),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Informe a descricao';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                enabled: false,
                initialValue: _editando ? widget.item!.data : _dataAtual(),
                decoration: _inputDecoration(
                    'Data de criacao', Icons.calendar_today_outlined),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF4F46E5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }
}
