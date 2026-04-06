import 'package:flutter_test/flutter_test.dart';

import 'package:aula09/main.dart';

void main() {
  testWidgets('App smoke test – HomeScreen carrega', (WidgetTester tester) async {
    await tester.pumpWidget(const MeuDiarioApp());
    // Verifica que a AppBar com o título do app aparece
    expect(find.text('Meu Diário'), findsOneWidget);
  });
}
