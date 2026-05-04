import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manutencao_predial_prototipo_mobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ManutencaoPredialApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
