import 'package:flutter_test/flutter_test.dart';
import 'package:psicoapp/main.dart';

void main() {
  testWidgets('PSICOAPP smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PsicoApp());
    expect(find.text('PSICOAPP'), findsWidgets);
  });
}
