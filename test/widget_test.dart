import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alerta_ja/app.dart';
import 'package:alerta_ja/services/local_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Splash abre painel sem timers pendentes', (tester) async {
    SharedPreferences.setMockInitialValues({'intro_seen': true});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(AlertaJaApp(store: LocalStore(prefs)));
    expect(find.text('AlertaJá'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
