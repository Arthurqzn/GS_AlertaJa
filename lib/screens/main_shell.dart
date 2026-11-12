import 'package:flutter/material.dart';
import '../models/occurrence.dart';
import '../services/local_store.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'occurrences_screen.dart';
import 'new_occurrence_screen.dart';
import 'weather_screen.dart';
import 'insights_screen.dart';
import 'radar_screen.dart';

class OccurrenceController extends ChangeNotifier {
  OccurrenceController(this.store) : items = store.getOccurrences();
  final LocalStore store;
  List<Occurrence> items;
  Future<void> persist() async { await store.saveOccurrences(items); notifyListeners(); }
  Future<void> add(Occurrence item) async { items = [item, ...items]; await persist(); }
  Future<void> update(Occurrence item) async { items = items.map((e) => e.id == item.id ? item : e).toList(); await persist(); }
  Future<void> remove(Occurrence item) async { items = items.where((e) => e.id != item.id).toList(); await persist(); }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.store});
  final LocalStore store;
  @override
  State<MainShell> createState() => _MainShellState();
}
class _MainShellState extends State<MainShell> {
  int selected = 0;
  late final OccurrenceController controller;
  @override void initState() { super.initState(); controller = OccurrenceController(widget.store); }
  @override void dispose() { controller.dispose(); super.dispose(); }
  Future<void> add(Occurrence item) async { await controller.add(item); if (mounted) setState(() => selected = 1); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: controller, builder: (context, _) {
    final items = controller.items;
    final screens = [
      HomeScreen(items: items, onNew: () => setState(() => selected = 2), onList: () => setState(() => selected = 1), onWeather: () => setState(() => selected = 4), onInsights: () => setState(() => selected = 3)),
      OccurrencesScreen(items: items, onUpdate: controller.update, onDelete: controller.remove),
      NewOccurrenceScreen(onSave: add),
      InsightsScreen(items: items),
      const WeatherScreen(),
      RadarScreen(items: items),
    ];
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        child: KeyedSubtree(key: ValueKey(selected), child: screens[selected]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (v) => setState(() => selected = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard, color: AppColors.purple), label: 'Painel'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt, color: AppColors.purple), label: 'Registros'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle, color: AppColors.red), label: 'Registrar'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights, color: AppColors.purple), label: 'Insights'),
          NavigationDestination(icon: Icon(Icons.cloud_outlined), selectedIcon: Icon(Icons.cloud, color: AppColors.purple), label: 'Clima'),
          NavigationDestination(icon: Icon(Icons.radar_outlined), selectedIcon: Icon(Icons.radar, color: AppColors.red), label: 'Radar'),
        ],
      ),
    );
  });
}
