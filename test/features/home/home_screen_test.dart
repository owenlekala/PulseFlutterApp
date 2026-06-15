import 'package:app_template/core/theme/app_theme.dart';
import 'package:app_template/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('home shell navigates between real-life feature pages', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(null),
        child: MaterialApp(
          theme: AppTheme.getLightTheme(),
          home: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('Good morning, Maya'), findsOneWidget);
    expect(find.text('Daily readiness'), findsOneWidget);

    await tester.tap(find.text('Activity').last);
    await tester.pumpAndSettle();

    expect(find.text('Your weekly rhythm'), findsOneWidget);
    expect(find.text('Create a plan'), findsOneWidget);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();

    expect(find.text('Maya Johnson'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Preferences'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Daily reminders'), findsOneWidget);
  });
}
