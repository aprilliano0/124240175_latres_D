import 'package:flutter_test/flutter_test.dart';
import 'package:latres_d/main.dart';
import 'package:latres_d/routes/app_routes.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialRoute: AppRoutes.login));
    expect(find.byType(MyApp), findsOneWidget);
  });
}
