import 'package:flutter/material.dart';
import '../services/local_store.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.store});
  final LocalStore store;
  @override State<OnboardingScreen> createState() => _OnboardingScreenState();
}
class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int page = 0;
  bool dontShow = true;
  final pages = const [
    _Intro(icon: Icons.location_city_outlined, title: 'Olhe pelo seu bairro', text: 'Registre situações de risco urbano, como pontos de alagamento observados pela comunidade.'),
    _Intro(icon: Icons.edit_note, title: 'Registre o que observou', text: 'Informe o local, descreva a situação e indique a gravidade percebida. O registro fica salvo no aparelho.'),
    _Intro(icon: Icons.groups_2_outlined, title: 'Acompanhe informações', text: 'Consulte ocorrências e veja dados meteorológicos públicos para contextualizar o cenário.'),
  ];
  Future<void> finish() async {
    if (dontShow) await widget.store.setIntroSeen(true);
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainShell(store: widget.store)));
  }
  @override void dispose() { controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Padding(
    padding: const EdgeInsets.fromLTRB(22, 12, 22, 22), child: Column(children: [
      Align(alignment: Alignment.centerRight, child: TextButton(onPressed: finish, child: const Text('Pular'))),
      Expanded(child: PageView(controller: controller, onPageChanged: (v) => setState(() => page = v), children: pages)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => AnimatedContainer(
        duration: const Duration(milliseconds: 180), margin: const EdgeInsets.all(4), width: page == i ? 23 : 8, height: 8,
        decoration: BoxDecoration(color: page == i ? const Color(0xFF9A65FF) : Colors.blueGrey.shade100, borderRadius: BorderRadius.circular(20))))),
      const SizedBox(height: 14),
      CheckboxListTile(contentPadding: EdgeInsets.zero, value: dontShow, onChanged: (v) => setState(() => dontShow = v ?? false),
        title: const Text('Não mostrar novamente', style: TextStyle(fontSize: 13)), controlAffinity: ListTileControlAffinity.leading),
      Row(children: [
        if (page > 0) OutlinedButton(onPressed: () => controller.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut), child: const Text('Voltar')) else const SizedBox(width: 80),
        const Spacer(),
        FilledButton(onPressed: () => page == 2 ? finish() : controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
          child: Text(page == 2 ? 'Começar' : 'Avançar')),
      ]),
    ]),
  )));
}

class _Intro extends StatelessWidget {
  const _Intro({required this.icon, required this.title, required this.text});
  final IconData icon; final String title, text;
  @override Widget build(BuildContext context) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 165, height: 165, decoration: BoxDecoration(color: const Color(0xFF30213F), borderRadius: BorderRadius.circular(42)),
      child: Icon(icon, size: 85, color: const Color(0xFF9A65FF))),
    const SizedBox(height: 32),
    Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
    const SizedBox(height: 13), Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.white70)),
  ]);
}
