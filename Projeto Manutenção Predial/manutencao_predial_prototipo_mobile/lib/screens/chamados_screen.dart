import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../database/database_helper.dart';
import '../models/chamado.dart';
import '../widgets/app_drawer.dart';
import '../widgets/chamado_card.dart';

class ChamadosScreen extends StatefulWidget {
  final String? userName;
  const ChamadosScreen({super.key, this.userName});

  @override
  State<ChamadosScreen> createState() => _ChamadosScreenState();
}

class _ChamadosScreenState extends State<ChamadosScreen> {
  final _db = DatabaseHelper.instance;
  List<Chamado> _chamados = [];
  bool _loading = true;

  String _filtroStatus = '';
  String _filtroTipo = '';
  String _filtroPrioridade = '';

  static const _tipoOpcoes = ['', 'Corretiva', 'Preventiva', 'Indevida'];
  static const _prioridadeOpcoes = ['', 'Alta', 'Média', 'Baixa'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _db.getChamados(
      status: _filtroStatus.isEmpty ? null : _filtroStatus,
      tipo: _filtroTipo.isEmpty ? null : _filtroTipo,
      prioridade: _filtroPrioridade.isEmpty ? null : _filtroPrioridade,
    );
    if (mounted) setState(() { _chamados = data; _loading = false; });
  }

  Future<void> _deletar(int id) async {
    await _db.deleteChamado(id);
    _load();
  }

  bool get _hasFilter =>
      _filtroStatus.isNotEmpty || _filtroTipo.isNotEmpty || _filtroPrioridade.isNotEmpty;

  void _showFiltros() {
    String tmpStatus = _filtroStatus;
    String tmpTipo = _filtroTipo;
    String tmpPrioridade = _filtroPrioridade;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text('Filtros Avançados',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close, color: AppColors.textSecondary)),
              ]),
              const SizedBox(height: 20),
              _DropField(
                label: 'Tipo Manutenção',
                value: tmpTipo,
                items: _tipoOpcoes,
                onChanged: (v) => setModal(() => tmpTipo = v ?? ''),
              ),
              const SizedBox(height: 16),
              _DropField(
                label: 'Prioridade',
                value: tmpPrioridade,
                items: _prioridadeOpcoes,
                onChanged: (v) => setModal(() => tmpPrioridade = v ?? ''),
              ),
              const SizedBox(height: 28),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setModal(() {
                      tmpStatus = '';
                      tmpTipo = '';
                      tmpPrioridade = '';
                    }),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.cardBorder),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Limpar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _filtroStatus = tmpStatus;
                        _filtroTipo = tmpTipo;
                        _filtroPrioridade = tmpPrioridade;
                      });
                      Navigator.pop(ctx);
                      _load();
                    },
                    child: const Text('Aplicar Filtros'),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void _showNovoChamado() {
    final tituloCtrl = TextEditingController();
    final localCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final respCtrl = TextEditingController();
    String tipo = 'Corretiva';
    String prioridade = 'Média';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('Novo Chamado',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close,
                          color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 16),
                _InputField('Título', tituloCtrl, 'Ex: Vazamento no teto...'),
                const SizedBox(height: 12),
                _InputField('Local', localCtrl, 'Bloco / Sala...'),
                const SizedBox(height: 12),
                _InputField('Responsável', respCtrl, 'Nome do técnico',
                    optional: true),
                const SizedBox(height: 12),
                _InputField('Descrição', descCtrl, 'Detalhes adicionais...',
                    maxLines: 3, optional: true),
                const SizedBox(height: 12),
                _DropField(
                  label: 'Tipo',
                  value: tipo,
                  items: const ['Corretiva', 'Preventiva', 'Indevida'],
                  onChanged: (v) => setModal(() => tipo = v ?? tipo),
                ),
                const SizedBox(height: 12),
                _DropField(
                  label: 'Prioridade',
                  value: prioridade,
                  items: const ['Alta', 'Média', 'Baixa'],
                  onChanged: (v) => setModal(() => prioridade = v ?? prioridade),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (tituloCtrl.text.trim().isEmpty ||
                        localCtrl.text.trim().isEmpty) return;
                    final now = DateTime.now().toIso8601String();
                    await _db.insertChamado(Chamado(
                      titulo: tituloCtrl.text.trim(),
                      local: localCtrl.text.trim(),
                      status: 'Pendente',
                      tipo: tipo,
                      prioridade: prioridade,
                      descricao: descCtrl.text.trim().isEmpty
                          ? null
                          : descCtrl.text.trim(),
                      responsavel: respCtrl.text.trim().isEmpty
                          ? null
                          : respCtrl.text.trim(),
                      dataAbertura: now,
                      dataAtualizacao: now,
                    ));
                    if (ctx.mounted) Navigator.pop(ctx);
                    _load();
                  },
                  child: const Text('Criar Chamado'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: AppDrawer(currentIndex: 1, userName: widget.userName),
      appBar: AppBar(
        title: const Text('Chamados'),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: _showFiltros,
                icon: const Icon(Icons.filter_list_outlined),
              ),
              if (_hasFilter)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh_outlined)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNovoChamado,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Status chips
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _StatusChip(
                  label: 'Todos',
                  selected: _filtroStatus.isEmpty,
                  onTap: () {
                    setState(() => _filtroStatus = '');
                    _load();
                  },
                ),
                _StatusChip(
                  label: 'Pendente',
                  selected: _filtroStatus == 'Pendente',
                  color: AppColors.statusPendente,
                  onTap: () {
                    setState(() => _filtroStatus = 'Pendente');
                    _load();
                  },
                ),
                _StatusChip(
                  label: 'Em Andamento',
                  selected: _filtroStatus == 'Em Andamento',
                  color: AppColors.statusEmAndamento,
                  onTap: () {
                    setState(() => _filtroStatus = 'Em Andamento');
                    _load();
                  },
                ),
                _StatusChip(
                  label: 'Concluído',
                  selected: _filtroStatus == 'Concluído',
                  color: AppColors.statusConcluido,
                  onTap: () {
                    setState(() => _filtroStatus = 'Concluído');
                    _load();
                  },
                ),
                _StatusChip(
                  label: 'Alerta',
                  selected: _filtroStatus == 'Alerta',
                  color: AppColors.statusAlerta,
                  onTap: () {
                    setState(() => _filtroStatus = 'Alerta');
                    _load();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : _chamados.isEmpty
                    ? _EmptyState(hasFilter: _hasFilter)
                    : RefreshIndicator(
                        onRefresh: _load,
                        color: AppColors.primary,
                        backgroundColor: AppColors.card,
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: _chamados.length,
                          itemBuilder: (ctx, i) => ChamadoCard(
                            chamado: _chamados[i],
                            onDelete: () => _deletar(_chamados[i].id!),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.withAlpha(38) : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? c : AppColors.cardBorder,
            width: selected ? 1 : 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? c : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _DropField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          dropdownColor: AppColors.card,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          hint: const Text('Todos',
              style: TextStyle(color: AppColors.textSecondary)),
          decoration: const InputDecoration(),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e.isEmpty ? null : e,
                    child: Text(e.isEmpty ? 'Todos' : e),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final bool optional;

  const _InputField(
    this.label,
    this.controller,
    this.hint, {
    this.maxLines = 1,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          if (optional)
            const Text(' (opcional)',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
        ]),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasFilter;
  const _EmptyState({required this.hasFilter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilter ? Icons.search_off_outlined : Icons.assignment_outlined,
            color: AppColors.textSecondary,
            size: 56,
          ),
          const SizedBox(height: 16),
          Text(
            hasFilter
                ? 'Nenhum chamado encontrado'
                : 'Sem chamados cadastrados',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
          ),
          if (hasFilter) ...[
            const SizedBox(height: 8),
            const Text('Tente ajustar os filtros',
                style:
                    TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}
