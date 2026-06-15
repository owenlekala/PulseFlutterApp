import 'package:flutter/material.dart';

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
        DropdownButtonFormField<T>(
          key: _fieldKey,
          initialValue: widget.value,
          items: widget.items,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.disabled,
          focusNode: _effectiveFocusNode,
          forceErrorText: widget.errorText,
          style: inputTextStyle,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            helperText: widget.helperText,
          ),
          onTap: () {
            _hasInteracted = true;
          },
          onChanged: widget.enabled
              ? (value) {
                  _hasInteracted = true;
                  _validateInline();
                  widget.onChanged?.call(value);
                }
              : null,
        ),
      ],
    );
  }
}
