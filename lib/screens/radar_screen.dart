import 'package:flutter/material.dart';
import '../models/occurrence.dart';
import '../theme/app_theme.dart';

class RadarScreen extends StatelessWidget {
  const RadarScreen({super.key, required this.items});
  final List<Occurrence> items;

  @override
  Widget build(BuildContext context) {
    final pending = items.where((e) => e.statusType == OccurrenceStatus.pendente).toList();
    final high = pending.where((e) => e.severityType == Severity.alta).length;
    final medium = pending.where((e) => e.severityType == Severity.moderada).length;
    final low = pending.length - high - medium;
    final score = items.isEmpty ? 0 : ((high * 3 + medium * 2 + low) * 100 / (items.length * 3)).round().clamp(0, 100);
    final counts = <String, int>{};
    for (final item in pending) {
      final name = item.neighborhood.trim();
      if (name.isNotEmpty) counts[name] = (counts[name] ?? 0) + 1;
    }
    final neighborhoods = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final now = DateTime.now();
    final days = List.generate(7, (i) => DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - i)));
    final daily = days.map((day) => items.where((e) => e.createdAt.year == day.year && e.createdAt.month == day.month && e.createdAt.day == day.day).length).toList();
    final peak = daily.fold<int>(1, (a, b) => b > a ? b : a);
    return Scaffold(appBar: AppBar(title: const Text('Radar urbano'), actions: [IconButton(onPressed: () => showAboutDialog(context: context, applicationName: 'AlertaJá 3.0', children: [const Text('Indicadores experimentais baseados somente nos relatos cadastrados neste dispositivo. Não são alertas oficiais.')]), icon: const Icon(Icons.info_outline))]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors: [Color(0xFF41206E), Color(0xFF301B36), Color(0xFF171723)])), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('URBAN INTELLIGENCE • ANÁLISE LOCAL', style: TextStyle(fontSize: 11, letterSpacing: 1.2, color: Color(0xFFE0C7FF))),
          const SizedBox(height: 14), const Text('Índice de atenção', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8), TweenAnimationBuilder<double>(tween: Tween(begin: 0, end: score.toDouble()), duration: const Duration(milliseconds: 900), builder: (_, value, __) => Text('${value.round()}/100', style: const TextStyle(fontSize: 43, fontWeight: FontWeight.w900, color: Color(0xFFFF6B8D)))),
          const SizedBox(height: 8), LinearProgressIndicator(value: score / 100, minHeight: 10, borderRadius: BorderRadius.circular(10), color: AppColors.red, backgroundColor: Colors.white12),
          const SizedBox(height: 12), const Text('Indicador demonstrativo: soma ponderada de relatos pendentes por gravidade, dividida pelo máximo possível. Não mede risco real.', style: TextStyle(fontSize: 12, color: Color(0xFFE3D8EB))),
        ])),
        const SizedBox(height: 18), Row(children: [Expanded(child: _Stat('Alta pendente', high, AppColors.red)), const SizedBox(width: 9), Expanded(child: _Stat('Moderada pendente', medium, AppColors.purple)), const SizedBox(width: 9), Expanded(child: _Stat('Baixa pendente', low, const Color(0xFF5EE6B4)))]),
        const SizedBox(height: 18), _Panel(title: 'Atividade dos últimos 7 dias', icon: Icons.show_chart, child: SizedBox(height: 140, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(7, (i) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [Text('${daily[i]}', style: const TextStyle(fontSize: 11, color: AppColors.muted)), const SizedBox(height: 5), TweenAnimationBuilder<double>(tween: Tween(begin: 0, end: daily[i] / peak), duration: Duration(milliseconds: 400 + i * 80), builder: (_, v, __) => Container(height: 85 * v + 3, decoration: BoxDecoration(color: i == 6 ? AppColors.red : AppColors.purple, borderRadius: BorderRadius.circular(7)))), const SizedBox(height: 7), Text('${days[i].day}/${days[i].month}', style: const TextStyle(fontSize: 9, color: AppColors.muted))]))))))),
        const SizedBox(height: 14), _Panel(title: 'Bairros com alertas pendentes', icon: Icons.location_city, child: neighborhoods.isEmpty ? const Text('Nenhum bairro com ocorrência pendente.', style: TextStyle(color: AppColors.muted)) : Column(children: neighborhoods.take(6).map((e) => Padding(padding: const EdgeInsets.only(bottom: 13), child: Column(children: [Row(children: [Expanded(child: Text(e.key)), Text('${e.value}', style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.bold))]), const SizedBox(height: 6), LinearProgressIndicator(value: e.value / neighborhoods.first.value, minHeight: 7, borderRadius: BorderRadius.circular(6), color: AppColors.purple, backgroundColor: Colors.white10)]))).toList())),
        const SizedBox(height: 14), _Panel(title: 'Orientações de prevenção', icon: Icons.health_and_safety_outlined, child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('• Evite áreas alagadas e não atravesse correntezas.'), SizedBox(height: 9), Text('• Em situação de emergência, procure os órgãos oficiais.'), SizedBox(height: 9), Text('• Cadastre relatos com informações objetivas, sem expor dados pessoais.'), SizedBox(height: 12), Text('Brasil: Defesa Civil 199 • Bombeiros 193', style: TextStyle(color: Color(0xFFFF829B), fontWeight: FontWeight.bold))])),
        const SizedBox(height: 16), const Text('Dados armazenados localmente. Os gráficos refletem apenas registros deste aparelho e não substituem informações oficiais.', style: TextStyle(color: AppColors.muted, fontSize: 11), textAlign: TextAlign.center),
      ]));
  }
}
class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.color);
  final String label; final int value; final Color color;
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('$value', style: TextStyle(color: color, fontSize: 27, fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 10))])));
}
class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.icon, required this.child});
  final String title; final IconData icon; final Widget child;
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(17), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, color: AppColors.purple), const SizedBox(width: 8), Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))]), const SizedBox(height: 16), child])));
}
