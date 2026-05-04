import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/chamado.dart';
import 'common_widgets.dart';

class ChamadoCard extends StatelessWidget {
  final Chamado chamado;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ChamadoCard({
    super.key,
    required this.chamado,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PrioridadeIndicator(prioridade: chamado.prioridade),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chamado.titulo,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      StatusChip(status: chamado.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: AppColors.textSecondary, size: 13),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          chamado.local,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.build_outlined,
                          color: AppColors.textSecondary, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        '${chamado.tipo} · ${chamado.prioridade}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      if (chamado.responsavel != null)
                        Text(
                          chamado.responsavel!,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.textSecondary, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}

class _PrioridadeIndicator extends StatelessWidget {
  final String prioridade;
  const _PrioridadeIndicator({required this.prioridade});

  Color get _color {
    switch (prioridade) {
      case 'Alta':
        return AppColors.primary;
      case 'Média':
        return AppColors.statusEmAndamento;
      default:
        return AppColors.statusConcluido;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 60,
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
