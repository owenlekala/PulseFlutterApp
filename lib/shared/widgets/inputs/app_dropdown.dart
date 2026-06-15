import 'package:flutter/material.dart';

class _DropdownSelection<T> {
  final T? value;

  const _DropdownSelection(this.value);
}

class AppDropdown<T> extends StatefulWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final Widget? prefixIcon;
  final String? helperText;
  final String? errorText;
  final bool enableInlineValidation;
  final FocusNode? focusNode;

  const AppDropdown({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.helperText,
    this.errorText,
    this.enableInlineValidation = true,
    this.focusNode,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final GlobalKey<FormFieldState<T>> _fieldKey = GlobalKey<FormFieldState<T>>();
  FocusNode? _internalFocusNode;
  bool _hasInteracted = false;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode == null ? FocusNode() : null;
    _effectiveFocusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _fieldKey.currentState?.didChange(widget.value);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      if (oldWidget.focusNode == null && widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      _internalFocusNode ??= widget.focusNode == null ? FocusNode() : null;
      _effectiveFocusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
    if (!_effectiveFocusNode.hasFocus) {
      _validateInline();
    }
  }

  void _validateInline() {
    if (!widget.enableInlineValidation || widget.validator == null) {
      return;
    }

    if (_hasInteracted) {
      _fieldKey.currentState?.validate();
    }
  }

  Future<void> _showOptions() async {
    if (!widget.enabled) {
      return;
    }

    _hasInteracted = true;
    _effectiveFocusNode.requestFocus();
    final selectedValue = _fieldKey.currentState?.value ?? widget.value;

    final selection = await showModalBottomSheet<_DropdownSelection<T>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.75,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.label ?? widget.hint ?? 'Select an option',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isSelected = item.value == selectedValue;

                      return ListTile(
                        enabled: item.enabled,
                        selected: isSelected,
                        title: item.child,
                        trailing: isSelected
                            ? Icon(
                                Icons.check_rounded,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                        onTap: item.enabled
                            ? () => Navigator.pop(
                                context,
                                _DropdownSelection<T>(item.value),
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) {
      return;
    }

    _effectiveFocusNode.unfocus();
    if (selection == null) {
      _validateInline();
      return;
    }

    _fieldKey.currentState?.didChange(selection.value);
    _validateInline();
    widget.onChanged?.call(selection.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTextStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(widget.label!, style: theme.textTheme.labelLarge),
          ),
        FormField<T>(
          key: _fieldKey,
          initialValue: widget.value,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.disabled,
          forceErrorText: widget.errorText,
          builder: (field) {
            DropdownMenuItem<T>? selectedItem;
            for (final item in widget.items) {
              if (item.value == field.value) {
                selectedItem = item;
                break;
              }
            }

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.enabled ? _showOptions : null,
              child: InputDecorator(
                isEmpty: selectedItem == null,
                isFocused: _effectiveFocusNode.hasFocus,
                decoration: InputDecoration(
                  enabled: widget.enabled,
                  prefixIcon: widget.prefixIcon,
                  helperText: widget.helperText,
                  errorText: field.errorText,
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                child: DefaultTextStyle(
                  style: inputTextStyle ?? const TextStyle(),
                  child:
                      selectedItem?.child ??
                      Text(
                        widget.hint ?? '',
                        style: inputTextStyle?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
