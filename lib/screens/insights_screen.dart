import 'package:flutter/material.dart';
import '../models/occurrence.dart';
import '../theme/app_theme.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key, required this.items});
  final List<Occurrence> items;

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    final neighborhoods = <String, int>{};
    for (final item in items) {
      counts[item.category] = (counts[item.category] ?? 0) + 1;
      final neighborhood = item.neighborhood.trim();
      if (neighborhood.isNotEmpty) {
        neighborhoods[neighborhood] = (neighborhoods[neighborhood] ?? 0) + 1;
      }
    }
    final categories = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final areas = neighborhoods.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final high = items.where((e) => e.severity == 'Alta' && e.status != 'Rejeitada').length;
    final pending = items.where((e) => e.status == 'Pendente').length;
    return Scaffold(
      appBar: AppBar(title: const Text('Inteligência urbana', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 26), children: [
        Container(padding: const EdgeInsets.all(21), decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF39225C), Color(0xFF2C172C), Color(0xFF171722)]),
          borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.purple.withValues(alpha: .25)),
        ), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.auto_graph, color: AppColors.purple), SizedBox(width: 8), Text('ANÁLISE LOCAL', style: TextStyle(fontSize: 11, letterSpacing: 1.4, fontWeight: FontWeight.w800))]),
          const SizedBox(height: 15),
          const Text('Dados que contam a história da sua região', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('${items.length} relatos armazenados neste dispositivo.', style: const TextStyle(color: AppColors.muted)),
        ])),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _Kpi('Pendentes', pending, Icons.pending_actions, AppColors.red)),
          const SizedBox(width: 10),
          Expanded(child: _Kpi('Gravidade alta', high, Icons.priority_high, AppColors.purple)),
        ]),
        const SizedBox(height: 18),
        _Section(title: 'Ocorrências por categoria', icon: Icons.donut_large, children: categories.isEmpty
          ? [const Text('Cadastre uma ocorrência para visualizar os indicadores.', style: TextStyle(color: AppColors.muted))]
          : categories.map((e) => _Bar(label: e.key, value: e.value, max: items.length, color: AppColors.purple)).toList()),
        const SizedBox(height: 14),
        _Section(title: 'Bairros com mais registros', icon: Icons.location_city, children: areas.isEmpty
          ? [const Text('Nenhum bairro registrado ainda.', style: TextStyle(color: AppColors.muted))]
          : areas.take(6).map((e) => _Bar(label: e.key, value: e.value, max: items.length, color: AppColors.red)).toList()),
        const SizedBox(height: 14),
        _Section(title: 'Atividade recente', icon: Icons.history, children: items.isEmpty
          ? [const Text('Nenhuma atividade recente.', style: TextStyle(color: AppColors.muted))]
          : (items.toList()..sort((a,b) => b.createdAt.compareTo(a.createdAt))).take(5).map((e) =>
              ListTile(contentPadding: EdgeInsets.zero, leading: const CircleAvatar(backgroundColor: Color(0xFF302140), child: Icon(Icons.radar, color: AppColors.purple, size: 19)),
                title: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('${e.neighborhood} • ${e.status}'),
                trailing: Text('${e.createdAt.day.toString().padLeft(2,'0')}/${e.createdAt.month.toString().padLeft(2,'0')}', style: const TextStyle(color: AppColors.muted, fontSize: 12)))).toList()),
        const SizedBox(height: 14),
        const Text('Indicadores calculados somente com relatos cadastrados neste aparelho. Não são estatísticas oficiais nem previsão de desastres.',
          textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, fontSize: 11)),
      ]),
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi(this.label, this.value, this.icon, this.color);
  final String label; final int value; final IconData icon; final Color color;
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Icon(icon, color: color), const SizedBox(height: 10),
    TweenAnimationBuilder<double>(duration: const Duration(milliseconds: 700), tween: Tween(begin: 0, end: value.toDouble()),
      builder: (context, n, _) => Text('${n.round()}', style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w900))),
    Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
  ])));
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.icon, required this.children});
  final String title; final IconData icon; final List<Widget> children;
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(17), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Icon(icon, color: AppColors.purple, size: 20), const SizedBox(width: 8), Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)))]),
    const SizedBox(height: 13), ...children,
  ])));
}

class _Bar extends StatelessWidget {
  const _Bar({required this.label, required this.value, required this.max, required this.color});
  final String label; final int value, max; final Color color;
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 13), child: Column(children: [
    Row(children: [Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)), Text('$value', style: TextStyle(color: color, fontWeight: FontWeight.w800))]),
    const SizedBox(height: 6), ClipRRect(borderRadius: BorderRadius.circular(8), child: TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: max == 0 ? 0 : value / max), duration: const Duration(milliseconds: 750),
      builder: (context, progress, _) => LinearProgressIndicator(value: progress, minHeight: 8, color: color, backgroundColor: AppColors.surfaceAlt),
    )),
  ]));
}
