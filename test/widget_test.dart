import 'package:flutter_app/app.dart';
import 'package:flutter_app/state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Orbit dashboard renders', (tester) async {
    await tester.pumpWidget(OrbitApp(state: AppState.demo()));
    await tester.pump();

    expect(find.textContaining('Good day'), findsOneWidget);
    expect(find.text('Up next'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Focus'), findsOneWidget);
  });

  testWidgets('can navigate to tasks', (tester) async {
    await tester.pumpWidget(OrbitApp(state: AppState.demo()));

    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();

    expect(find.text('Search your tasks'), findsOneWidget);
    expect(find.text('Plan the day'), findsOneWidget);
  });
}
