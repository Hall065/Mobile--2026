import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/nota.dart';

class DetalhesScreen extends StatefulWidget {
  final Nota nota;
  final List<int> coresDisponiveis;

  const DetalhesScreen({
    super.key,
    required this.nota,
    required this.coresDisponiveis,
  });

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  final _db = DatabaseHelper.instance;

  late TextEditingController _tituloCtrl;
  late TextEditingController _corpoCtrl;
  late int _corSelecionada;

  bool _editando = false;
  bool _salvando = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController(text: widget.nota.titulo);
    _corpoCtrl = TextEditingController(text: widget.nota.corpo);
    _corSelecionada = widget.nota.cor;
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _corpoCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvarEdicao() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);

    final atualizada = widget.nota.copyWith(
      titulo: _tituloCtrl.text.trim(),
      corpo: _corpoCtrl.text.trim(),
      cor: _corSelecionada,
    );

    await _db.atualizarNota(atualizada);
    setState(() {
      _salvando = false;
      _editando = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nota atualizada!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmarDelecao() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir nota?'),
        content:
            const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _db.deletarNota(widget.nota.id!);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cor = Color(_corSelecionada);

    return Scaffold(
      backgroundColor: cor.withAlpha(20),
      appBar: AppBar(
        backgroundColor: cor,
        foregroundColor: Colors.white,
        title: Text(
          _editando ? 'Editando' : 'Detalhes',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          if (!_editando) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Editar',
              onPressed: () => setState(() => _editando = true),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Excluir',
              onPressed: _confirmarDelecao,
            ),
          ] else ...[
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
                    onPressed: _salvarEdicao,
                    icon: const Icon(Icons.save_outlined, color: Colors.white),
                    label: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Restaura valores originais ao cancelar
                _tituloCtrl.text = widget.nota.titulo;
                _corpoCtrl.text = widget.nota.corpo;
                setState(() {
                  _corSelecionada = widget.nota.cor;
                  _editando = false;
                });
              },
            ),
          ],
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── Cabeçalho da data ────────────────────────────────────────────
            if (!_editando)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: cor),
                    const SizedBox(width: 6),
                    Text(
                      _formatarData(widget.nota.criado),
                      style: TextStyle(
                        fontSize: 12,
                        color: cor.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),

            // ── Título ──────────────────────────────────────────────────────
            _card(
              cor: cor,
              child: _editando
                  ? TextFormField(
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
                          (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.nota.titulo,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: cor,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 14),

            // ── Corpo ────────────────────────────────────────────────────────
            _card(
              cor: cor,
              child: _editando
                  ? TextFormField(
                      controller: _corpoCtrl,
                      decoration: InputDecoration(
                        labelText: 'Conteúdo',
                        labelStyle: TextStyle(color: cor),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.edit_note_outlined, color: cor),
                        alignLabelWithHint: true,
                      ),
                      style: const TextStyle(fontSize: 16, height: 1.6),
                      maxLines: 12,
                      minLines: 5,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.nota.corpo,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ),
            ),

            // ── Seletor de cor (apenas ao editar) ────────────────────────────
            if (_editando) ...[
              const SizedBox(height: 22),
              const Text(
                'Cor da nota',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF616161),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                children: widget.coresDisponiveis.map((c) {
                  final sel = c == _corSelecionada;
                  return GestureDetector(
                    onTap: () => setState(() => _corSelecionada = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: sel
                            ? Border.all(color: Colors.black54, width: 3)
                            : null,
                        boxShadow: sel
                            ? [
                                BoxShadow(
                                  color: Color(c).withAlpha(120),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : null,
                      ),
                      child: sel
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _card({required Color cor, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cor.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  String _formatarData(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}
