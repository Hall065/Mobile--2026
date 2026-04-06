import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/nota.dart';

class NovaNoteScreen extends StatefulWidget {
  final List<int> coresDisponiveis;

  const NovaNoteScreen({super.key, required this.coresDisponiveis});

  @override
  State<NovaNoteScreen> createState() => _NovaNoteScreenState();
}

class _NovaNoteScreenState extends State<NovaNoteScreen> {
  final _db = DatabaseHelper.instance;
  final _tituloCtrl = TextEditingController();
  final _corpoCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _corSelecionada = 0xFF6C63FF;
  bool _salvando = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _corpoCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final nova = Nota(
      titulo: _tituloCtrl.text.trim(),
      corpo: _corpoCtrl.text.trim(),
      cor: _corSelecionada,
      criado: DateTime.now().toUtc().toIso8601String(),
    );

    await _db.inserirNota(nova);

    setState(() => _salvando = false);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cor = Color(_corSelecionada);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: cor,
        foregroundColor: Colors.white,
        title: const Text(
          'Nova Nota',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          _salvando
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : TextButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.save_outlined, color: Colors.white),
                  label: const Text('Salvar',
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── Título ──────────────────────────────────────────────────────
            _card(
              child: TextFormField(
                controller: _tituloCtrl,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: cor),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.title, color: cor),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLength: 80,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Digite um título' : null,
              ),
            ),
            const SizedBox(height: 14),

            // ── Conteúdo ─────────────────────────────────────────────────────
            _card(
              child: TextFormField(
                controller: _corpoCtrl,
                decoration: InputDecoration(
                  labelText: 'Escreva aqui…',
                  labelStyle: TextStyle(color: cor),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.edit_note_outlined, color: cor),
                  alignLabelWithHint: true,
                ),
                style: const TextStyle(fontSize: 16, height: 1.5),
                maxLines: 10,
                minLines: 5,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Escreva algo' : null,
              ),
            ),
            const SizedBox(height: 22),

            // ── Cor da nota ──────────────────────────────────────────────────
            const Text(
              'Escolha uma cor',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              children: widget.coresDisponiveis.map((c) {
                final selecionada = c == _corSelecionada;
                return GestureDetector(
                  onTap: () => setState(() => _corSelecionada = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(c),
                      shape: BoxShape.circle,
                      border: selecionada
                          ? Border.all(
                              color: Colors.black54,
                              width: 3,
                            )
                          : null,
                      boxShadow: selecionada
                          ? [
                              BoxShadow(
                                color: Color(c).withAlpha(120),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    child: selecionada
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
