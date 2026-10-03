import 'package:flutter_app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('starter home screen renders', (tester) async {
    await tester.pumpWidget(const FlutterStarterApp());

    expect(find.text('Your Flutter app is ready.'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
