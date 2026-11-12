import 'package:flutter/material.dart';
import '../models/occurrence.dart';
import '../theme/app_theme.dart';
import '../widgets/occurrence_card.dart';
import 'occurrence_detail_screen.dart';

class OccurrencesScreen extends StatefulWidget {
  const OccurrencesScreen({super.key, required this.items, required this.onUpdate, required this.onDelete});
  final List<Occurrence> items;
  final ValueChanged<Occurrence> onUpdate, onDelete;
  @override
  State<OccurrencesScreen> createState() => _OccurrencesScreenState();
}
class _OccurrencesScreenState extends State<OccurrencesScreen> {
  String filter = 'Todas';
  String search = '';
  bool onlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    final query = search.toLowerCase().trim();
    final list = widget.items.where((e) =>
      (filter == 'Todas' || e.status == filter) &&
      (!onlyFavorites || e.favorite) &&
      (e.title.toLowerCase().contains(query) || e.neighborhood.toLowerCase().contains(query) || e.description.toLowerCase().contains(query))
    ).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Ocorrências', style: TextStyle(fontWeight: FontWeight.w800)), actions: [
        IconButton(tooltip: 'Somente favoritas', onPressed: () => setState(() => onlyFavorites = !onlyFavorites), icon: Icon(onlyFavorites ? Icons.star : Icons.star_border, color: onlyFavorites ? const Color(0xFFFFCB65) : AppColors.muted)),
      ]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), child: TextField(
          decoration: const InputDecoration(hintText: 'Buscar por título, bairro ou descrição', prefixIcon: Icon(Icons.search)),
          onChanged: (v) => setState(() => search = v),
        )),
        SizedBox(height: 48, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), children: [
          for (final f in ['Todas', 'Pendente', 'Validada', 'Rejeitada']) Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(label: Text(f), selected: filter == f, onSelected: (_) => setState(() => filter = f)),
          ),
        ])),
        Padding(padding: const EdgeInsets.fromLTRB(17, 10, 17, 6), child: Row(children: [
          Text('${list.length} registro(s)', style: const TextStyle(color: AppColors.muted)),
          if (onlyFavorites) const Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.star, size: 15, color: Color(0xFFFFCB65))),
        ])),
        Expanded(child: list.isEmpty
          ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.search_off, color: AppColors.purple, size: 42), SizedBox(height: 10), Text('Nenhuma ocorrência encontrada.'), SizedBox(height: 4), Text('Tente outro filtro ou pesquisa.', style: TextStyle(color: AppColors.muted))]))
          : ListView.builder(padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), itemCount: list.length, itemBuilder: (context, i) {
            final item = list[i];
            return OccurrenceCard(
              item: item,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OccurrenceDetailScreen(item: item, onUpdate: widget.onUpdate, onDelete: widget.onDelete))),
              onFavorite: () => widget.onUpdate(item.copyWith(favorite: !item.favorite)),
            );
          })),
      ]),
    );
  }
}
