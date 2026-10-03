import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/app.dart';

void main() {
  testWidgets('starter home screen renders', (tester) async {
    await tester.pumpWidget(const FlutterStarterApp());

    expect(find.text('Your Flutter app is ready.'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
