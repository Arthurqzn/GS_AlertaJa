import 'package:flutter/material.dart';
import '../models/occurrence.dart';
import '../theme/app_theme.dart';

IconData categoryIcon(OccurrenceCategory category) => switch (category) {
  OccurrenceCategory.buraco => Icons.construction,
  OccurrenceCategory.iluminacao => Icons.lightbulb_outline,
  OccurrenceCategory.descarte => Icons.delete_outline,
  OccurrenceCategory.arvore => Icons.park_outlined,
  OccurrenceCategory.bueiro => Icons.water,
  OccurrenceCategory.deslizamento => Icons.landscape_outlined,
  OccurrenceCategory.outro => Icons.report_outlined,
  _ => Icons.water_damage_outlined,
};

class OccurrenceCard extends StatelessWidget {
  const OccurrenceCard({super.key, required this.item, required this.onTap, this.onFavorite});
  final Occurrence item;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final color = item.status == 'Validada'
        ? const Color(0xFF44D6AA)
        : item.status == 'Rejeitada' ? AppColors.red : AppColors.purple;
    final high = item.severity == 'Alta';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: (high ? AppColors.red : AppColors.purple).withValues(alpha: .15), borderRadius: BorderRadius.circular(12)),
                child: Icon(categoryIcon(item.categoryType), color: high ? AppColors.red : AppColors.purple),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 3),
                Text(item.neighborhood, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ])),
              if (onFavorite != null) IconButton(
                tooltip: item.favorite ? 'Remover favorito' : 'Favoritar',
                onPressed: onFavorite,
                icon: Icon(item.favorite ? Icons.star_rounded : Icons.star_border_rounded, color: item.favorite ? const Color(0xFFFFCB65) : AppColors.muted),
              ),
            ]),
            const SizedBox(height: 11),
            Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, height: 1.45)),
            const SizedBox(height: 13),
            Wrap(spacing: 8, runSpacing: 7, children: [
              _Tag(item.status, color),
              _Tag(item.category, AppColors.purple),
              _Tag('Gravidade ${item.severity}', high ? AppColors.red : AppColors.muted),
            ]),
          ]),
        ),
      ),
    );
  }
}
class _Tag extends StatelessWidget {
  const _Tag(this.label, this.color);
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(30)),
    child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
  );
}
