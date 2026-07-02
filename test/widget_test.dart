// Phase 1 smoke test: the foundation (theme + DI + routing skeleton) boots
// without throwing. Real widget/feature tests arrive with each module.

import 'package:flutter_test/flutter_test.dart';

import 'package:exam_app/main.dart';

void main() {
  testWidgets('ExamApp builds and shows the splash placeholder route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ExamApp());
    await tester.pumpAndSettle();

    expect(find.byType(ExamApp), findsOneWidget);
  });
}
