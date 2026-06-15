import 'package:flutter/material.dart';

class AppFilterChipOption<T> {
  final T value;
  final String label;

  const AppFilterChipOption({required this.value, required this.label});
}

class AppFilterChipGroup<T> extends StatelessWidget {
  final List<AppFilterChipOption<T>> options;
  final Set<T> selectedValues;
  final ValueChanged<Set<T>>? onChanged;

  const AppFilterChipGroup({
    super.key,
    required this.options,
    required this.selectedValues,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final selected = selectedValues.contains(option.value);

        return FilterChip(
          label: Text(option.label),
          selected: selected,
          onSelected: onChanged == null
              ? null
              : (isSelected) {
                  final next = {...selectedValues};
                  if (isSelected) {
                    next.add(option.value);
                  } else {
                    next.remove(option.value);
                  }
                  onChanged!(next);
                },
        );
      }).toList(),
    );
  }
}
