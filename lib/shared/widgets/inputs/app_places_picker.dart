import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/utils/app_icons.dart';
import '../../../core/config/app_config.dart';

class PlacePrediction {
  final String placeId;
  final String description;
  final String? secondaryText;

  PlacePrediction({
    required this.placeId,
    required this.description,
    this.secondaryText,
  });
}

class AppPlacesPicker extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final void Function(PlacePrediction)? onPlaceSelected;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? helperText;
  final String? errorText;
  final String? apiKey;
  final String? countryCode;

  const AppPlacesPicker({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.onPlaceSelected,
    this.validator,
    this.enabled = true,
    this.helperText,
    this.errorText,
    this.apiKey,
    this.countryCode,
  });

  @override
  State<AppPlacesPicker> createState() => _AppPlacesPickerState();
}

class _AppPlacesPickerState extends State<AppPlacesPicker> {
  late TextEditingController _controller;
  List<PlacePrediction> _predictions = [];
  bool _showSuggestions = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _controller.text.isNotEmpty) {
      _searchPlaces(_controller.text);
    } else {
      _hideSuggestions();
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _showSuggestions = false;
      });
      _removeOverlay();
      return;
    }

    // Get platform-specific API key
    final apiKey = widget.apiKey ??
        (Platform.isAndroid
            ? AppConfig.googleMapsApiKeyAndroid
            : Platform.isIOS
                ? AppConfig.googleMapsApiKeyIOS
                : '');
    
    if (apiKey.isEmpty) {
      return;
    }

    try {
      final countryParam = widget.countryCode != null
          ? '&components=country:${widget.countryCode}'
          : '';
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeComponent(query)}'
        '&key=$apiKey'
        '$countryParam',
      );

      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' && mounted) {
        final predictions = (data['predictions'] as List)
            .map((prediction) => PlacePrediction(
                  placeId: prediction['place_id'],
                  description: prediction['description'],
                  secondaryText: prediction['structured_formatting']?['secondary_text'],
                ))
            .toList();

        setState(() {
          _predictions = predictions;
          _showSuggestions = predictions.isNotEmpty;
        });

        if (_showSuggestions) {
          _showSuggestionsOverlay();
        } else {
          _removeOverlay();
        }
      }
    } catch (e) {
      // Handle error silently or show error message
      if (mounted) {
        setState(() {
          _predictions = [];
          _showSuggestions = false;
        });
        _removeOverlay();
      }
    }
  }

  void _showSuggestionsOverlay() {
    _removeOverlay();
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(context).colorScheme.surface,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  final prediction = _predictions[index];
                  return ListTile(
                    leading: Icon(
                      AppIcons.location,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(prediction.description),
                    subtitle: prediction.secondaryText != null
                        ? Text(prediction.secondaryText!)
                        : null,
                    onTap: () {
                      _controller.text = prediction.description;
                      _focusNode.unfocus();
                      _hideSuggestions();
                      if (widget.onPlaceSelected != null) {
                        widget.onPlaceSelected!(prediction);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideSuggestions() {
    setState(() {
      _showSuggestions = false;
    });
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style: theme.textTheme.labelLarge,
            ),
          ),
        CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            validator: widget.validator,
            onChanged: _searchPlaces,
            decoration: InputDecoration(
              hintText: widget.hint ?? 'Search for a place',
              prefixIcon: Icon(
                AppIcons.location,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              helperText: widget.helperText,
              errorText: widget.errorText,
            ),
          ),
        ),
      ],
    );
  }
}
