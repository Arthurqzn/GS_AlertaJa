import 'package:flutter/material.dart';
import '../models/occurrence.dart';
import '../theme/app_theme.dart';
import 'new_occurrence_screen.dart';

class OccurrenceDetailScreen extends StatelessWidget {
  const OccurrenceDetailScreen({super.key, required this.item, required this.onUpdate, required this.onDelete});
  final Occurrence item;
  final ValueChanged<Occurrence> onUpdate, onDelete;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detalhes da ocorrência')),
    body: ListView(padding: const EdgeInsets.all(17), children: [
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.report_problem_outlined, color: AppColors.red, size: 32),
        const SizedBox(height: 12),
        Text(item.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        _Info('Bairro', item.neighborhood),
        _Info('Endereço', item.address.isEmpty ? 'Não informado' : item.address),
        _Info('Categoria', item.category),
        _Info('Gravidade', item.severity),
        _Info('Situação', item.status),
        _Info('Criada em', '${item.createdAt.day.toString().padLeft(2, '0')}/${item.createdAt.month.toString().padLeft(2, '0')}/${item.createdAt.year}'),
        const Divider(height: 25),
        Text(item.description, style: const TextStyle(height: 1.5)),
      ]))),
      const SizedBox(height: 16),
      FilledButton.icon(onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) =>
          NewOccurrenceScreen(initial: item, onSave: onUpdate)));
        if (context.mounted) Navigator.pop(context);
      }, icon: const Icon(Icons.edit_outlined), label: const Text('Editar ocorrência')),
      const SizedBox(height: 16),
      const Text('Atualizar situação (simulação local)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      const SizedBox(height: 10),
      Wrap(spacing: 8, children: [for (final status in ['Pendente', 'Validada', 'Rejeitada']) ActionChip(
        label: Text(status), onPressed: () { onUpdate(item.copyWith(status: status)); Navigator.pop(context); },
      )]),
      const SizedBox(height: 20),
      OutlinedButton.icon(onPressed: () async {
        final confirmed = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
          title: const Text('Excluir ocorrência?'),
          content: const Text('Essa ação remove o registro deste aparelho.'),
          actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
            FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Excluir'))],
        ));
        if (confirmed == true && context.mounted) { onDelete(item); Navigator.pop(context); }
      }, icon: const Icon(Icons.delete_outline, color: AppColors.red), label: const Text('Excluir registro', style: TextStyle(color: AppColors.red))),
    ]),
  );
}
class _Info extends StatelessWidget {
  const _Info(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 9), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(width: 88, child: Text(label, style: const TextStyle(color: AppColors.muted))),
    Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
  ]));
}
