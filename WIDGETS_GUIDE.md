# Widgets Guide

This document provides an overview of all available widgets in the app template and how to use them.

## Input Widgets

### AppTextField

A customizable text field with validation and password toggle support.

```dart
AppTextField(
  label: 'Email',
  hint: 'Enter your email',
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  },
  onChanged: (value) {
    // Handle text change
  },
)
```

### AppDropdown

A styled dropdown with consistent theming.

```dart
AppDropdown<String>(
  label: 'Select Option',
  hint: 'Choose an option',
  value: selectedValue,
  items: [
    DropdownMenuItem(value: 'option1', child: Text('Option 1')),
    DropdownMenuItem(value: 'option2', child: Text('Option 2')),
  ],
  onChanged: (value) {
    setState(() {
      selectedValue = value;
    });
  },
)
```

### AppDatePicker

A date picker with Mingcute calendar icon.

```dart
AppDatePicker(
  label: 'Select Date',
  hint: 'Choose a date',
  selectedDate: selectedDate,
  onDateSelected: (date) {
    setState(() {
      selectedDate = date;
    });
  },
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
  validator: (date) {
    if (date == null) {
      return 'Please select a date';
    }
    return null;
  },
)
```

### AppTimePicker

A time picker with Mingcute clock icon.

```dart
AppTimePicker(
  label: 'Select Time',
  hint: 'Choose a time',
  selectedTime: selectedTime,
  onTimeSelected: (time) {
    setState(() {
      selectedTime = time;
    });
  },
  use24HourFormat: false, // or true for 24-hour format
)
```

### AppPlacesPicker

A places autocomplete picker using Google Places API.

```dart
AppPlacesPicker(
  label: 'Location',
  hint: 'Search for a place',
  onPlaceSelected: (prediction) {
    print('Selected place: ${prediction.description}');
    print('Place ID: ${prediction.placeId}');
  },
  countryCode: 'us', // Optional: restrict to specific country
)
```

**Note**: Requires Google Maps API key to be configured in `.env` file.

## Button Widgets

### AppButton

A versatile button with multiple styles and sizes.

```dart
// Primary button
AppButton(
  text: 'Submit',
  type: AppButtonType.primary,
  onPressed: () {
    // Handle press
  },
)

// Secondary button
AppButton(
  text: 'Cancel',
  type: AppButtonType.secondary,
  onPressed: () {},
)

// Outlined button
AppButton(
  text: 'Learn More',
  type: AppButtonType.outlined,
  onPressed: () {},
)

// Text button
AppButton(
  text: 'Skip',
  type: AppButtonType.text,
  onPressed: () {},
)

// With icon
AppButton(
  text: 'Save',
  type: AppButtonType.primary,
  icon: Icon(AppIcons.save),
  onPressed: () {},
)

// Loading state
AppButton(
  text: 'Loading...',
  type: AppButtonType.primary,
  isLoading: true,
  onPressed: null,
)

// Full width
AppButton(
  text: 'Full Width Button',
  type: AppButtonType.primary,
  isFullWidth: true,
  onPressed: () {},
)
```

### AppIconButton

A circular icon button with tooltip support.

```dart
AppIconButton(
  icon: AppIcons.settings,
  onPressed: () {
    // Handle press
  },
  tooltip: 'Settings',
)
```

## Card Widgets

### AppCard

A reusable card component with elevation and padding.

```dart
AppCard(
  child: Column(
    children: [
      Text('Card Title'),
      Text('Card content'),
    ],
  ),
  onTap: () {
    // Handle tap
  },
)

// Custom styling
AppCard(
  padding: EdgeInsets.all(24),
  margin: EdgeInsets.all(16),
  elevation: 4,
  borderRadius: BorderRadius.circular(16),
  child: Text('Custom Card'),
)
```

## Loading Widgets

### AppLoadingIndicator

Loading indicators in circular or linear format.

```dart
// Circular loading
AppLoadingIndicator(
  type: AppLoadingType.circular,
  message: 'Loading...',
)

// Linear loading
AppLoadingIndicator(
  type: AppLoadingType.linear,
)

// Custom size and color
AppLoadingIndicator(
  type: AppLoadingType.circular,
  size: 40,
  color: Colors.blue,
  strokeWidth: 4,
)
```

## Dialog Widgets

### AppDialog

A customizable dialog with icon support.

```dart
AppDialog.show(
  context: context,
  title: 'Confirm Action',
  message: 'Are you sure you want to proceed?',
  confirmText: 'Yes',
  cancelText: 'No',
  icon: AppIcons.warning,
  onConfirm: () {
    // Handle confirm
  },
  onCancel: () {
    // Handle cancel
  },
)
```

### AppAlertDialog

A simple alert dialog.

```dart
AppAlertDialog.show(
  context: context,
  title: 'Success',
  message: 'Operation completed successfully!',
  buttonText: 'OK',
  icon: AppIcons.checkCircle,
  onPressed: () {
    Navigator.pop(context);
  },
)
```

### AppConfirmDialog

A confirmation dialog.

```dart
AppConfirmDialog.show(
  context: context,
  title: 'Delete Item',
  message: 'Are you sure you want to delete this item?',
  confirmText: 'Delete',
  cancelText: 'Cancel',
  onConfirm: () {
    // Handle delete
  },
)
```

## Chart Widgets

### AppLineChart

A line chart widget.

```dart
AppLineChart(
  title: 'Sales Over Time',
  spots: [
    FlSpot(0, 3),
    FlSpot(1, 1),
    FlSpot(2, 5),
    FlSpot(3, 4),
  ],
  showGrid: true,
  showPoints: true,
)
```

### AppBarChart

A bar chart widget.

```dart
AppBarChart(
  title: 'Monthly Sales',
  barGroups: [
    BarChartGroupData(x: 0, barRods: [
      BarChartRodData(toY: 8, color: Colors.blue),
    ]),
    BarChartGroupData(x: 1, barRods: [
      BarChartRodData(toY: 5, color: Colors.blue),
    ]),
  ],
  bottomLabels: ['Jan', 'Feb', 'Mar'],
)
```

### AppPieChart

A pie chart widget.

```dart
AppPieChart(
  title: 'Distribution',
  data: [
    PieChartData(label: 'Category A', value: 30, color: Colors.blue),
    PieChartData(label: 'Category B', value: 40, color: Colors.green),
    PieChartData(label: 'Category C', value: 30, color: Colors.orange),
  ],
  showLegend: true,
)
```

## Map Widgets

### AppGoogleMap

A Google Maps widget.

```dart
AppGoogleMap(
  latitude: 37.7749,
  longitude: -122.4194,
  zoom: 14,
  markers: {
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.7749, -122.4194),
      infoWindow: InfoWindow(title: 'Location'),
    ),
  },
  myLocationEnabled: true,
  onTap: (latLng) {
    print('Tapped at: $latLng');
  },
)
```

**Note**: Requires Google Maps API key to be configured.

## Theme Compatibility

All widgets are designed to work seamlessly with the app's theme system. They automatically adapt to:
- Light and dark modes
- Material 3 design system
- Custom color schemes
- Text styles from the theme

Widgets use `Theme.of(context)` to access theme colors and styles, ensuring consistent appearance across the app.

## Best Practices

1. **Always provide labels**: Use the `label` parameter for better accessibility
2. **Validate inputs**: Use the `validator` parameter for form validation
3. **Handle loading states**: Use `isLoading` for buttons during async operations
4. **Use appropriate icons**: Leverage `AppIcons` for consistent iconography
5. **Follow Material Design**: Widgets follow Material 3 guidelines

