import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';
import '../database/database_helper.dart';
import '../models/agendamento.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common_widgets.dart';
import '../widgets/pie_chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  final String? userName;
  const DashboardScreen({super.key, this.userName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _db = DatabaseHelper.instance;
  bool _loading = true;
  Map<String, int> _statusStats = {};
  Map<String, int> _tiposStats = {};
  List<Agendamento> _agendamentos = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final status = await _db.getChamadosStats();
    final tipos = await _db.getTiposStats();
    final agenda = await _db.getAgendamentosHoje();
    if (mounted) {
      setState(() {
        _statusStats = status;
        _tiposStats = tipos;
        _agendamentos = agenda;
        _loading = false;
      });
    }
  }

  int _stat(String key) => _statusStats[key] ?? 0;
  int get _total => _statusStats.values.fold(0, (a, b) => a + b);

  String get _percentPendente {
    if (_total == 0) return '0%';
    final pct = (_stat('Pendente') / _total * 100);
    return '${pct.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();
    final dataFormatada = DateFormat("EEE, d 'de' MMMM", 'pt_BR').format(hoje);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: AppDrawer(currentIndex: 0, userName: widget.userName),
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _load,
              color: AppColors.primary,
              backgroundColor: AppColors.card,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ── Stats Cards ─────────────────────────────
                  Row(
                    children: [
                      StatCard(
                        label: 'Chamados Abertos',
                        value: _stat('Pendente') + _stat('Em Andamento') + _stat('Alerta'),
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      StatCard(
                        label: 'Em Andamento',
                        value: _stat('Em Andamento'),
                        color: AppColors.statusEmAndamento,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      StatCard(
                        label: 'Pendentes',
                        value: _stat('Pendente'),
                        color: AppColors.statusAlerta,
                      ),
                      const SizedBox(width: 12),
                      StatCard(
                        label: 'Concluídos',
                        value: _stat('Concluído'),
                        color: AppColors.statusConcluido,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Chamados por Status ──────────────────────
                  _SectionCard(
                    title: 'Chamados por Status',
                    child: PieChartWidget(
                      centerLabel: _percentPendente,
                      data: {
                        'Alertas': _stat('Alerta').toDouble(),
                        'Em Andamento': _stat('Em Andamento').toDouble(),
                        'Pendentes': _stat('Pendente').toDouble(),
                        'Concluídos': _stat('Concluído').toDouble(),
                      },
                      colors: const {
                        'Alertas': AppColors.chartAlerta,
                        'Em Andamento': AppColors.chartEmAndamento,
                        'Pendentes': AppColors.chartPendente,
                        'Concluídos': AppColors.chartConcluido,
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Tipos de Manutenção ──────────────────────
                  _SectionCard(
                    title: 'Tipos de Manutenção',
                    trailing: TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/chamados'),
                      child: const Text('Ver Todos',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                    child: Column(
                      children: [
                        PieChartWidget(
                          centerLabel: _tiposStats.isNotEmpty
                              ? '${(_stat('Corretiva') / (_total == 0 ? 1 : _total) * 100).toStringAsFixed(1)}%'
                              : '0%',
                          data: {
                            'Corretiva': (_tiposStats['Corretiva'] ?? 0).toDouble(),
                            'Preventiva': (_tiposStats['Preventiva'] ?? 0).toDouble(),
                            'Indevida': (_tiposStats['Indevida'] ?? 0).toDouble(),
                          },
                          colors: const {
                            'Corretiva': AppColors.chartCorretiva,
                            'Preventiva': AppColors.chartPreventiva,
                            'Indevida': AppColors.chartIndevida,
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Agendamentos Hoje ────────────────────────
                  _SectionCard(
                    title: 'Agendamentos hoje',
                    subtitle: _capitalize(dataFormatada),
                    trailing: TextButton(
                      onPressed: () {},
                      child: const Text('Ver Todos',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                    child: _agendamentos.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text('Nenhum agendamento para hoje',
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13)),
                            ),
                          )
                        : Column(
                            children: _agendamentos
                                .map((a) => _AgendaItem(agendamento: a))
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Section Card ───────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;

  const _SectionCard({
    required this.title,
    this.subtitle,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ── Agenda Item ────────────────────────────────────────────────────────────────

class _AgendaItem extends StatelessWidget {
  final Agendamento agendamento;
  const _AgendaItem({required this.agendamento});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(
              agendamento.horario,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: 2,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.cardBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agendamento.titulo,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  agendamento.local,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          if (agendamento.tipo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                agendamento.tipo!,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }
}
