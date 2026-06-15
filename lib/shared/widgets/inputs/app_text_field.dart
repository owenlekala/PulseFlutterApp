import 'package:flutter/material.dart';
import '../../../core/utils/app_icons.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showPasswordToggle;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? helperText;
  final String? errorText;
  final bool enableInlineValidation;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.showPasswordToggle = false,
    this.focusNode,
    this.textInputAction,
    this.helperText,
    this.errorText,
    this.enableInlineValidation = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late TextEditingController _controller;
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();
  FocusNode? _internalFocusNode;
  bool _hasInteracted = false;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _internalFocusNode = widget.focusNode == null ? FocusNode() : null;
    _effectiveFocusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
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
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
    final inputTextStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        TextFormField(
          key: _fieldKey,
          controller: _controller,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          style: inputTextStyle,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.disabled,
          forceErrorText: widget.errorText,
          onChanged: (value) {
            _hasInteracted = true;
            _validateInline();
            widget.onChanged?.call(value);
          },
          onFieldSubmitted: widget.onSubmitted,
          onTap: () {
            _hasInteracted = true;
            widget.onTap?.call();
          },
          focusNode: _effectiveFocusNode,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.showPasswordToggle
                ? IconButton(
                    icon: Icon(_obscureText ? AppIcons.eyeOff : AppIcons.eye),
                    onPressed: _toggleObscureText,
                  )
                : widget.suffixIcon,
            helperText: widget.helperText,
          ),
        ),
      ],
    );
  }
}
