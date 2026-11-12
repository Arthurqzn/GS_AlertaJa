
import 'package:flutter/material.dart';
import '../models/weather_info.dart';
import '../services/weather_service.dart';
import '../theme/app_theme.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}
class _WeatherScreenState extends State<WeatherScreen> {
  late Future<WeatherInfo> weather;
  @override
  void initState() { super.initState(); weather = WeatherService().fetch(); }
  void reload() => setState(() => weather = WeatherService().fetch());
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Clima • localização atual', style: TextStyle(fontWeight: FontWeight.w800)), actions: [IconButton(tooltip: 'Atualizar', onPressed: reload, icon: const Icon(Icons.refresh))]),
    body: FutureBuilder<WeatherInfo>(future: weather, builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
      if (snapshot.hasError) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.cloud_off, color: AppColors.red, size: 44),
        const SizedBox(height: 12),
        const Text('Não foi possível consultar o clima.'),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Text('${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.muted))),
        const SizedBox(height: 12), FilledButton(onPressed: reload, child: const Text('Tentar novamente')),
      ]));
      final data = snapshot.data!;
      return ListView(padding: const EdgeInsets.all(18), children: [
        Container(padding: const EdgeInsets.all(25), decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(colors: [Color(0xFF40236D), Color(0xFF291B36), Color(0xFF431C32)]),
        ), child: Column(children: [
          const Icon(Icons.cloud_outlined, size: 66, color: AppColors.purple),
          const SizedBox(height: 14),
          Text('${data.temperature.toStringAsFixed(1)} °C', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
          Text(data.description, style: const TextStyle(color: AppColors.muted, fontSize: 17)),
          const SizedBox(height: 6),
          const Text('Condições atuais', style: TextStyle(fontSize: 11, color: AppColors.muted)),
        ])),
        const SizedBox(height: 18),
        Card(child: ListTile(leading: const Icon(Icons.water_drop_outlined, color: AppColors.purple), title: const Text('Umidade relativa'), trailing: Text('${data.humidity}%'))),
        Card(child: ListTile(leading: const Icon(Icons.air, color: AppColors.red), title: const Text('Velocidade do vento'), trailing: Text('${data.windSpeed.toStringAsFixed(1)} km/h'))),
        const SizedBox(height: 17),
        const Card(child: Padding(padding: EdgeInsets.all(17), child: Row(children: [Icon(Icons.info_outline, color: AppColors.purple), SizedBox(width: 12), Expanded(child: Text('Dados públicos de clima. Não representam alerta oficial nem previsão de alagamento.', style: TextStyle(fontSize: 12, color: AppColors.muted)))]))),
      ]);
    }),
  );
}
