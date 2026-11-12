import 'package:flutter/material.dart';
import '../models/occurrence.dart';
import '../theme/app_theme.dart';

class NewOccurrenceScreen extends StatefulWidget {
  const NewOccurrenceScreen({super.key, required this.onSave, this.initial});
  final ValueChanged<Occurrence> onSave;
  final Occurrence? initial;
  @override
  State<NewOccurrenceScreen> createState() => _NewOccurrenceScreenState();
}
class _NewOccurrenceScreenState extends State<NewOccurrenceScreen> {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  final neighborhood = TextEditingController();
  final address = TextEditingController();
  String severity = 'Moderada';
  String category = 'Alagamento';
  @override void initState() {
    super.initState();
    final item = widget.initial;
    if (item != null) {
      title.text = item.title; description.text = item.description;
      neighborhood.text = item.neighborhood; address.text = item.address;
      severity = item.severity; category = item.category;
    }
  }
  @override
  void dispose() { title.dispose(); description.dispose(); neighborhood.dispose(); address.dispose(); super.dispose(); }
  void submit() {
    if (!formKey.currentState!.validate()) return;
    widget.onSave(Occurrence(
      id: widget.initial?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.text.trim(), description: description.text.trim(),
      neighborhood: neighborhood.text.trim(), address: address.text.trim(),
      severity: severity, category: category, status: widget.initial?.status ?? 'Pendente', createdAt: widget.initial?.createdAt ?? DateTime.now(), favorite: widget.initial?.favorite ?? false,
    ));
    if (widget.initial != null) { Navigator.pop(context); return; }
    title.clear(); description.clear(); neighborhood.clear(); address.clear();
    setState(() { severity = 'Moderada'; category = 'Alagamento'; });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ocorrência registrada neste aparelho.')));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.initial == null ? 'Nova ocorrência' : 'Editar ocorrência', style: TextStyle(fontWeight: FontWeight.w800))),
    body: Form(key: formKey, child: ListView(padding: const EdgeInsets.all(17), children: [
      Container(padding: const EdgeInsets.all(19), decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF372050), Color(0xFF4B1E34)]), borderRadius: BorderRadius.circular(20),
      ), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.edit_location_alt_outlined, color: AppColors.red, size: 29), SizedBox(height: 10),
        Text('Ajude sua comunidade', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
        SizedBox(height: 6), Text('Descreva o problema com clareza. Seu relato ficará salvo localmente.', style: TextStyle(color: Color(0xFFDCD1E3))),
      ])),
      const SizedBox(height: 20),
      TextFormField(controller: title, decoration: const InputDecoration(labelText: 'Título da ocorrência *', prefixIcon: Icon(Icons.title)), validator: (v) => v == null || v.trim().isEmpty ? 'Informe um título.' : null),
      const SizedBox(height: 12),
      TextFormField(controller: description, minLines: 3, maxLines: 5, decoration: const InputDecoration(labelText: 'Descrição *', alignLabelWithHint: true, prefixIcon: Icon(Icons.notes)), validator: (v) => v == null || v.trim().isEmpty ? 'Descreva o problema.' : null),
      const SizedBox(height: 12),
      TextFormField(controller: neighborhood, decoration: const InputDecoration(labelText: 'Bairro *', prefixIcon: Icon(Icons.location_city)), validator: (v) => v == null || v.trim().isEmpty ? 'Informe o bairro.' : null),
      const SizedBox(height: 12),
      TextFormField(controller: address, decoration: const InputDecoration(labelText: 'Rua ou referência', prefixIcon: Icon(Icons.place_outlined))),
      const SizedBox(height: 18),
      const Text('Tipo de ocorrência', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      const SizedBox(height: 9),
      Wrap(spacing: 7, runSpacing: 4, children: [
        for (final value in OccurrenceCategory.values.map((e) => e.label))
          ChoiceChip(label: Text(value), selected: category == value,
            onSelected: (_) => setState(() => category = value)),
      ]),
      const SizedBox(height: 20),
      const Text('Gravidade percebida', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: [for (final v in Severity.values.map((e) => e.label)) ChoiceChip(
        label: Text(v), selected: severity == v, onSelected: (_) => setState(() => severity = v),
        selectedColor: (v == 'Alta' ? AppColors.red : AppColors.purple).withValues(alpha: .32),
      )]),
      const SizedBox(height: 24),
      FilledButton.icon(onPressed: submit, icon: const Icon(Icons.save_outlined), label: const Text('Salvar ocorrência'), style: FilledButton.styleFrom(backgroundColor: AppColors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 17))),
      const SizedBox(height: 12),
      const Text('Registro comunitário, não validado por órgãos oficiais.', style: TextStyle(fontSize: 11, color: AppColors.muted), textAlign: TextAlign.center),
    ])),
  );
}
