import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../database/database_helper.dart';
import '../models/estoque_item.dart';
import '../widgets/app_drawer.dart';

class EstoqueScreen extends StatefulWidget {
  final String? userName;
  const EstoqueScreen({super.key, this.userName});

  @override
  State<EstoqueScreen> createState() => _EstoqueScreenState();
}

class _EstoqueScreenState extends State<EstoqueScreen> {
  final _db = DatabaseHelper.instance;
  List<EstoqueItem> _itens = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _db.getEstoque();
    if (mounted) setState(() { _itens = data; _loading = false; });
  }

  Future<void> _deletar(int id) async {
    await _db.deleteEstoqueItem(id);
    _load();
  }

  void _showNovoItem() {
    final nomeCtrl = TextEditingController();
    final qtdCtrl = TextEditingController();
    final qtdMinCtrl = TextEditingController();
    final localCtrl = TextEditingController();
    String categoria = 'Elétrico';
    String unidade = 'un';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Novo Item',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _field('Nome', nomeCtrl, 'Ex: Lâmpada LED 40W'),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _field('Quantidade', qtdCtrl, '0',
                      type: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: _field('Qtd. Mínima', qtdMinCtrl, '0',
                      type: TextInputType.number)),
                ]),
                const SizedBox(height: 12),
                _dropField('Categoria', categoria,
                    ['Elétrico', 'Hidráulico', 'Pintura', 'Ferragem', 'Outros'],
                    (v) => setModal(() => categoria = v ?? categoria)),
                const SizedBox(height: 12),
                _dropField('Unidade', unidade,
                    ['un', 'm', 'kg', 'L', 'galão', 'rolo', 'caixa'],
                    (v) => setModal(() => unidade = v ?? unidade)),
                const SizedBox(height: 12),
                _field('Localização', localCtrl, 'Ex: Almoxarifado A'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (nomeCtrl.text.isEmpty) return;
                    await _db.insertEstoqueItem(EstoqueItem(
                      nome: nomeCtrl.text.trim(),
                      categoria: categoria,
                      quantidade: double.tryParse(qtdCtrl.text) ?? 0,
                      unidade: unidade,
                      quantidadeMinima: double.tryParse(qtdMinCtrl.text) ?? 0,
                      localizacao: localCtrl.text.trim(),
                      updatedAt: DateTime.now().toIso8601String(),
                    ));
                    if (ctx.mounted) Navigator.pop(ctx);
                    _load();
                  },
                  child: const Text('Adicionar Item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint,
      {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  Widget _dropField(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          dropdownColor: AppColors.card,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: const InputDecoration(),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final baixoEstoque = _itens.where((i) => i.estoqueBaixo).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: AppDrawer(currentIndex: 5, userName: widget.userName),
      appBar: AppBar(
        title: const Text('Estoque'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh_outlined)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNovoItem,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                if (baixoEstoque > 0)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.statusAlerta.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.statusAlerta.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_outlined,
                            color: AppColors.statusAlerta, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          '$baixoEstoque ${baixoEstoque == 1 ? 'item abaixo' : 'itens abaixo'} do estoque mínimo',
                          style: const TextStyle(
                              color: AppColors.statusAlerta,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: _itens.isEmpty
                      ? const Center(
                          child: Text('Nenhum item cadastrado',
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 14)))
                      : RefreshIndicator(
                          onRefresh: _load,
                          color: AppColors.primary,
                          backgroundColor: AppColors.card,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                            itemCount: _itens.length,
                            itemBuilder: (ctx, i) =>
                                _EstoqueCard(item: _itens[i], onDelete: () => _deletar(_itens[i].id!)),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class _EstoqueCard extends StatelessWidget {
  final EstoqueItem item;
  final VoidCallback onDelete;

  const _EstoqueCard({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final baixo = item.estoqueBaixo;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: baixo
              ? AppColors.statusAlerta.withOpacity(0.4)
              : AppColors.cardBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _catColor(item.categoria).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_catIcon(item.categoria),
                color: _catColor(item.categoria), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nome,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(item.categoria,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                    if (item.localizacao != null) ...[
                      const Text(' · ',
                          style: TextStyle(color: AppColors.textSecondary)),
                      Expanded(
                        child: Text(item.localizacao!,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.quantidade.toStringAsFixed(item.quantidade.truncateToDouble() == item.quantidade ? 0 : 1)} ${item.unidade}',
                style: TextStyle(
                  color: baixo ? AppColors.statusAlerta : AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text('mín: ${item.quantidadeMinima.toStringAsFixed(0)} ${item.unidade}',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline,
                color: AppColors.textSecondary, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Color _catColor(String cat) {
    switch (cat) {
      case 'Elétrico': return AppColors.statusAlerta;
      case 'Hidráulico': return const Color(0xFF29B6F6);
      case 'Pintura': return const Color(0xFFAB47BC);
      case 'Ferragem': return AppColors.textSecondary;
      default: return AppColors.statusEmAndamento;
    }
  }

  IconData _catIcon(String cat) {
    switch (cat) {
      case 'Elétrico': return Icons.electrical_services_outlined;
      case 'Hidráulico': return Icons.water_drop_outlined;
      case 'Pintura': return Icons.format_paint_outlined;
      case 'Ferragem': return Icons.hardware_outlined;
      default: return Icons.inventory_2_outlined;
    }
  }
}
