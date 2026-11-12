import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alerta_ja/models/occurrence.dart';
import 'package:alerta_ja/services/local_store.dart';

void main() {
  test('gravidade legada Média é normalizada para Moderada', () {
    expect(SeverityLabel.parse('Média'), Severity.moderada);
  });
  test('registro incompleto não apaga os demais', () async {
    SharedPreferences.setMockInitialValues({
      'occurrences': jsonEncode([
        {'id': '1', 'title': 'Buraco', 'severity': 'Média'},
        'registro inválido',
        {'id': '2', 'title': 'Poste', 'status': 'Pendente'},
      ]),
    });
    final store = LocalStore(await SharedPreferences.getInstance());
    final items = store.getOccurrences();
    expect(items.length, 2);
    expect(items.first.severity, 'Moderada');
    await store.saveOccurrences(items);
    expect(store.getOccurrences().length, 2);
  });
  test('edição mantém identificador e permite alterar campos', () {
    final item = Occurrence(id: '1', title: 'Antes', description: '', neighborhood: '', address: '', severity: 'Baixa', status: 'Pendente', createdAt: DateTime(2026));
    expect(item.copyWith(title: 'Depois').title, 'Depois');
    expect(item.copyWith(title: 'Depois').id, '1');
  });
}
