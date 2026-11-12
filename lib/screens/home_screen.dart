import 'package:flutter/material.dart';
import '../models/occurrence.dart';
import '../widgets/occurrence_card.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.items, required this.onNew, required this.onList, required this.onWeather, required this.onInsights});
  final List<Occurrence> items;
  final VoidCallback onNew, onList, onWeather, onInsights;

  @override
  Widget build(BuildContext context) {
    final pending = items.where((e) => e.status == 'Pendente').length;
    final valid = items.where((e) => e.status == 'Validada').length;
    final high = items.where((e) => e.severity == 'Alta').length;
    final latest = items.take(3).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [Icon(Icons.radar, color: AppColors.purple), SizedBox(width: 9), Text('AlertaJá', style: TextStyle(fontWeight: FontWeight.w800))]),
        actions: [IconButton(tooltip: 'Clima', onPressed: onWeather, icon: const Icon(Icons.cloud_outlined))],
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 10, 16, 24), children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 650), tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) => Opacity(opacity: value, child: Transform.translate(offset: Offset(0, 18 * (1 - value)), child: child)),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF4A237E), Color(0xFF1B1831), Color(0xFF541A35)]),
              border: Border.all(color: AppColors.purple.withValues(alpha: .35)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.shield_outlined, color: Color(0xFFFF829B)), SizedBox(width: 8), Text('CENTRAL COMUNITÁRIA', style: TextStyle(letterSpacing: 1.5, fontSize: 11, fontWeight: FontWeight.w700))]),
              const SizedBox(height: 16),
              const Text('Sua cidade.\nMais informação.', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, height: 1.12)),
              const SizedBox(height: 10),
              const Text('Registre problemas urbanos e acompanhe relatos da comunidade.', style: TextStyle(color: Color(0xFFE0D8EC), height: 1.5)),
              const SizedBox(height: 19),
              FilledButton.icon(onPressed: onNew, icon: const Icon(Icons.add_circle_outline), label: const Text('Nova ocorrência'), style: FilledButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13))),
            ]),
          ),
        ),
        const SizedBox(height: 23),
        const Text('Painel de monitoramento', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _Metric('Total', items.length, Icons.layers_outlined, AppColors.purple)),
          const SizedBox(width: 9),
          Expanded(child: _Metric('Pendentes', pending, Icons.schedule, AppColors.red)),
        ]),
        const SizedBox(height: 9),
        Row(children: [
          Expanded(child: _Metric('Validadas', valid, Icons.verified_outlined, const Color(0xFF44D6AA))),
          const SizedBox(width: 9),
          Expanded(child: _Metric('Gravidade alta', high, Icons.priority_high, const Color(0xFFFFA36C))),
        ]),
        const SizedBox(height: 15),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Distribuição dos registros', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(10), child: Row(children: [
            Expanded(flex: pending == 0 ? 1 : pending, child: Container(height: 11, color: AppColors.red)),
            Expanded(flex: valid == 0 ? 1 : valid, child: Container(height: 11, color: const Color(0xFF44D6AA))),
            Expanded(flex: (items.length - pending - valid) <= 0 ? 1 : (items.length - pending - valid), child: Container(height: 11, color: AppColors.purple)),
          ])),
          const SizedBox(height: 9),
          const Text('Vermelho: pendentes  •  Verde: validadas  •  Roxo: demais', style: TextStyle(fontSize: 10, color: AppColors.muted)),
          if (items.isEmpty) const Padding(padding: EdgeInsets.only(top: 8), child: Text('Sem registros: gráfico ilustrativo.', style: TextStyle(fontSize: 10, color: AppColors.muted))),
        ]))),
        const SizedBox(height: 13),
        Card(child: ListTile(onTap: onInsights, leading: const Icon(Icons.auto_graph, color: AppColors.purple),
          title: const Text('Inteligência urbana', style: TextStyle(fontWeight: FontWeight.w800)),
          subtitle: const Text('Categorias, bairros e histórico de relatos'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16))),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Últimas ocorrências', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
          TextButton(onPressed: onList, child: const Text('Ver todas')),
        ]),
        if (latest.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(22), child: Column(children: [Icon(Icons.inbox_outlined, color: AppColors.purple, size: 35), SizedBox(height: 8), Text('Nenhuma ocorrência ainda'), Text('Toque em Nova ocorrência para começar.', style: TextStyle(color: AppColors.muted, fontSize: 12))])))
        else ...latest.map((e) => OccurrenceCard(item: e, onTap: onList)),
        Card(child: ListTile(onTap: onWeather, leading: const Icon(Icons.cloud_outlined, color: AppColors.purple), title: const Text('Condições meteorológicas'), subtitle: const Text('Consultar clima atual em São Paulo'), trailing: const Icon(Icons.arrow_forward_ios, size: 16))),
        const SizedBox(height: 13),
        const Text('Protótipo acadêmico. Relatos não verificados; não substitui a Defesa Civil ou alertas oficiais.', style: TextStyle(color: AppColors.muted, fontSize: 11), textAlign: TextAlign.center),
      ]),
    );
  }
}
class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value, this.icon, this.color);
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(15), child: Row(children: [
    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: .13), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color)),
    const SizedBox(width: 11),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TweenAnimationBuilder<double>(duration: const Duration(milliseconds: 700), tween: Tween(begin: 0, end: value.toDouble()), builder: (context, v, _) => Text('${v.round()}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900))),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
    ])),
  ])));
}
