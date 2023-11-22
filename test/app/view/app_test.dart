import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App(
        user: User.anonymous,
      ));
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
