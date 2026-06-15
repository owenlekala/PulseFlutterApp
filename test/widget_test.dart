import 'package:app_template/core/theme/app_theme.dart';
import 'package:app_template/core/theme/app_theme_extensions.dart';
import 'package:app_template/shared/widgets/chips/app_status_chip.dart';
import 'package:app_template/shared/widgets/inputs/app_cupertino_date_time_field.dart';
import 'package:app_template/shared/widgets/inputs/app_dropdown.dart';
import 'package:app_template/shared/widgets/inputs/app_segmented_field.dart';
import 'package:app_template/shared/widgets/inputs/app_text_field.dart';
import 'package:app_template/shared/widgets/inputs/app_toggle_field.dart';
import 'package:app_template/shared/widgets/maps/app_google_map.dart';
import 'package:app_template/shared/widgets/media/app_avatar.dart';
import 'package:app_template/shared/widgets/navigation/app_tabs.dart';
import 'package:app_template/shared/widgets/uploads/app_upload_card.dart';
import 'package:app_template/shared/widgets/uploads/app_upload_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const mapsConfigChannel = MethodChannel('app_template/maps_platform_config');

  Widget wrapWithMaterialApp(Widget child, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme ?? AppTheme.getLightTheme(),
      home: Scaffold(
        body: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }

  testWidgets('AppDateField renders placeholder and confirms selection', (
    tester,
  ) async {
    DateTime? selected;

    await tester.pumpWidget(
      wrapWithMaterialApp(
        AppDateField(
          label: 'Pickup date',
          placeholder: 'Choose date',
          value: DateTime(2026, 6, 14),
          onChanged: (value) => selected = value,
        ),
      ),
    );

    expect(find.text('Pickup date'), findsOneWidget);
    expect(find.text('2026-06-14'), findsOneWidget);

    await tester.tap(find.text('2026-06-14'));
    await tester.pumpAndSettle();

    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(selected, DateTime(2026, 6, 14));
  });

  testWidgets('AppTimeField uses 24 hour formatting and cancel does not emit', (
    tester,
  ) async {
    DateTime? selected;

    await tester.pumpWidget(
      wrapWithMaterialApp(
        AppTimeField(
          label: 'Pickup time',
          value: DateTime(2026, 6, 14, 17, 30),
          use24hFormat: true,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    expect(find.text('17:30'), findsOneWidget);

    await tester.tap(find.text('17:30'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(selected, isNull);
  });

  testWidgets('AppToggleField toggles from row tap', (tester) async {
    bool value = false;

    await tester.pumpWidget(
      wrapWithMaterialApp(
        StatefulBuilder(
          builder: (context, setState) => AppToggleField(
            title: 'Push notifications',
            subtitle: 'Trip reminders',
            value: value,
            helperText: 'Helper',
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ),
    );

    expect(find.text('Push notifications'), findsOneWidget);
    expect(find.text('Helper'), findsOneWidget);

    await tester.tap(find.text('Push notifications'));
    await tester.pumpAndSettle();

    expect(value, isTrue);
  });

  testWidgets('AppSegmentedField emits selection changes', (tester) async {
    String selected = 'driver';

    await tester.pumpWidget(
      wrapWithMaterialApp(
        StatefulBuilder(
          builder: (context, setState) => AppSegmentedField<String>(
            label: 'Persona',
            value: selected,
            options: const [
              AppSegmentOption(value: 'driver', label: 'Driver'),
              AppSegmentOption(value: 'admin', label: 'Admin'),
            ],
            onChanged: (value) => setState(() => selected = value),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Admin'));
    await tester.pumpAndSettle();

    expect(selected, 'admin');
  });

  testWidgets('AppTextField shows inline validation after interaction', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        AppTextField(
          label: 'Full name',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full name is required';
            }
            return null;
          },
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'A');
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '');
    await tester.pump();

    expect(find.text('Full name is required'), findsOneWidget);
  });

  testWidgets(
    'AppDropdown shows inline validation after dismissing selection',
    (tester) async {
      await tester.pumpWidget(
        wrapWithMaterialApp(
          AppDropdown<String>(
            label: 'Role',
            hint: 'Choose role',
            items: const [
              DropdownMenuItem(value: 'driver', child: Text('Driver')),
              DropdownMenuItem(value: 'admin', child: Text('Admin')),
            ],
            validator: (value) {
              if (value == null) {
                return 'Role is required';
              }
              return null;
            },
          ),
        ),
      );

      await tester.tap(find.text('Choose role'));
      await tester.pumpAndSettle();
      expect(find.text('Role'), findsNWidgets(2));
      expect(find.byType(BottomSheet), findsOneWidget);
      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();

      expect(find.text('Role is required'), findsOneWidget);
    },
  );

  testWidgets('AppDropdown selects an option from a bottom sheet', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      wrapWithMaterialApp(
        AppDropdown<String>(
          label: 'Role',
          hint: 'Choose role',
          items: const [
            DropdownMenuItem(value: 'driver', child: Text('Driver')),
            DropdownMenuItem(value: 'admin', child: Text('Admin')),
          ],
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.text('Choose role'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Admin'));
    await tester.pumpAndSettle();

    expect(selected, 'admin');
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.text('Admin'), findsOneWidget);
  });

  testWidgets('AppAvatar can show edit button and emit callback', (
    tester,
  ) async {
    var editTapped = false;

    await tester.pumpWidget(
      wrapWithMaterialApp(
        AppAvatar(
          initials: 'JD',
          radius: 28,
          showEditButton: true,
          onEdit: () => editTapped = true,
        ),
      ),
    );

    expect(find.text('JD'), findsOneWidget);
    expect(find.byTooltip('Edit avatar'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit avatar'));
    await tester.pumpAndSettle();

    expect(editTapped, isTrue);
  });

  testWidgets('AppTabs renders tabs and switches content', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        AppTabs(
          tabs: const [
            AppTabItem(label: 'Overview'),
            AppTabItem(label: 'History'),
          ],
          height: 120,
          children: const [
            Center(child: Text('Overview body')),
            Center(child: Text('History body')),
          ],
        ),
      ),
    );

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Overview body'), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text('History body'), findsOneWidget);
  });

  testWidgets('AppUploadCard renders items and item actions fire', (
    tester,
  ) async {
    AppUploadItem? previewed;
    AppUploadItem? removed;
    AppUploadItem? retried;
    const item = AppUploadItem(
      id: 'policy',
      name: 'policy.pdf',
      extension: 'pdf',
      sizeBytes: 512000,
      state: AppUploadState.failed,
    );

    await tester.pumpWidget(
      wrapWithMaterialApp(
        AppUploadCard(
          title: 'Documents',
          items: const [item],
          state: AppUploadState.failed,
          onPreviewItem: (value) => previewed = value,
          onRemoveItem: (value) => removed = value,
          onRetryItem: (value) => retried = value,
        ),
      ),
    );

    expect(find.text('Documents'), findsOneWidget);
    expect(find.text('policy.pdf'), findsWidgets);
    expect(find.byType(AppStatusChip), findsOneWidget);

    await tester.tap(find.byTooltip('Retry upload'));
    await tester.pumpAndSettle();
    expect(retried?.id, 'policy');

    await tester.tap(find.byTooltip('Remove file').last);
    await tester.pumpAndSettle();
    expect(removed?.id, 'policy');

    expect(previewed, isNull);
  });

  test('theme extensions are available in light and dark themes', () {
    final AppSemanticColors lightColors = AppTheme.getLightTheme().appColors;
    final AppSemanticColors darkColors = AppTheme.getDarkTheme().appColors;

    expect(lightColors.fieldBackground, isNot(darkColors.fieldBackground));
    expect(lightColors.sheetBackground, isNot(darkColors.sheetBackground));
  });

  testWidgets(
    'AppGoogleMap shows fallback when native maps config is missing',
    (tester) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(mapsConfigChannel, (methodCall) async {
            if (methodCall.method == 'isGoogleMapsConfigured') {
              return false;
            }
            return null;
          });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(mapsConfigChannel, null);
      });

      await tester.pumpWidget(
        wrapWithMaterialApp(
          const SizedBox(
            height: 200,
            child: AppGoogleMap(latitude: -26.2041, longitude: 28.0473),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Google Maps API Key not configured'),
        findsOne,
      );
    },
  );
}
