import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/maps/maps_platform_config_service.dart';

class AppMapPin {
  final String id;
  final LatLng position;
  final String? title;
  final String? snippet;
  final BitmapDescriptor? icon;
  final double hue;
  final bool draggable;
  final VoidCallback? onTap;

  const AppMapPin({
    required this.id,
    required this.position,
    this.title,
    this.snippet,
    this.icon,
    this.hue = BitmapDescriptor.hueRed,
    this.draggable = false,
    this.onTap,
  });

  Marker toMarker() {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(title: title, snippet: snippet),
      icon: icon ?? BitmapDescriptor.defaultMarkerWithHue(hue),
      draggable: draggable,
      onTap: onTap,
    );
  }
}

class AppMapRouteLine {
  final String id;
  final List<LatLng> points;
  final Color color;
  final int width;
  final bool geodesic;

  const AppMapRouteLine({
    required this.id,
    required this.points,
    this.color = Colors.blue,
    this.width = 5,
    this.geodesic = true,
  });

  Polyline toPolyline() {
    return Polyline(
      polylineId: PolylineId(id),
      points: points,
      color: color,
      width: width,
      geodesic: geodesic,
    );
  }
}

class AppGoogleMap extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double? zoom;
  final Set<Marker>? markers;
  final List<AppMapPin>? pins;
  final Set<Polyline>? polylines;
  final List<AppMapRouteLine>? routeLines;
  final Set<Polygon>? polygons;
  final Set<Circle>? circles;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final MapType mapType;
  final void Function(LatLng)? onTap;
  final void Function(CameraPosition)? onCameraMove;
  final void Function(CameraPosition)? onCameraIdle;
  final void Function(LatLng)? onLongPress;

  const AppGoogleMap({
    super.key,
    this.latitude,
    this.longitude,
    this.zoom,
    this.markers,
    this.pins,
    this.polylines,
    this.routeLines,
    this.polygons,
    this.circles,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.mapType = MapType.normal,
    this.onTap,
    this.onCameraMove,
    this.onCameraIdle,
    this.onLongPress,
  });

  @override
  State<AppGoogleMap> createState() => _AppGoogleMapState();
}

class _AppGoogleMapState extends State<AppGoogleMap> {
  GoogleMapController? _mapController;
  late CameraPosition _initialCameraPosition;
  late final Future<bool> _isNativeMapConfigured;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(widget.latitude ?? 0.0, widget.longitude ?? 0.0),
      zoom: widget.zoom ?? 14.0,
    );
    _isNativeMapConfigured = MapsPlatformConfigService.isGoogleMapsConfigured();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isNativeMapConfigured,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.data != true) {
          return _MissingKeyState(
            platformLabel: Platform.isIOS ? 'iOS' : 'Android',
            envVariable: Platform.isIOS
                ? 'GOOGLE_MAPS_API_KEY_IOS'
                : 'GOOGLE_MAPS_API_KEY_ANDROID',
          );
        }

        final markers = {
          ...?widget.markers,
          ...?widget.pins?.map((pin) => pin.toMarker()),
        };
        final polylines = {
          ...?widget.polylines,
          ...?widget.routeLines?.map((route) => route.toPolyline()),
        };

        return GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          markers: markers,
          polylines: polylines,
          polygons: widget.polygons ?? {},
          circles: widget.circles ?? {},
          myLocationEnabled: widget.myLocationEnabled,
          myLocationButtonEnabled: widget.myLocationButtonEnabled,
          mapType: widget.mapType,
          onTap: widget.onTap,
          onCameraMove: widget.onCameraMove,
          onCameraIdle: widget.onCameraIdle != null
              ? () {
                  if (_mapController != null) {
                    _mapController!.getVisibleRegion().then((bounds) {
                      final center = LatLng(
                        (bounds.northeast.latitude +
                                bounds.southwest.latitude) /
                            2,
                        (bounds.northeast.longitude +
                                bounds.southwest.longitude) /
                            2,
                      );
                      widget.onCameraIdle!(
                        CameraPosition(target: center, zoom: 14.0),
                      );
                    });
                  }
                }
              : null,
          onLongPress: widget.onLongPress,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> animateToLocation(
    double latitude,
    double longitude, {
    double? zoom,
  }) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(latitude, longitude),
          zoom ?? widget.zoom ?? 14.0,
        ),
      );
    }
  }
}

class _MissingKeyState extends StatelessWidget {
  final String platformLabel;
  final String envVariable;

  const _MissingKeyState({
    required this.platformLabel,
    required this.envVariable,
  });

  @override
  Widget build(BuildContext context) {
    final configuredEnvVariable = _resolveConfiguredEnvVariable();
    final hasDartKey = !MapsPlatformConfigService.isPlaceholderValue(
      configuredEnvVariable,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Google Maps API Key not configured for $platformLabel',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Set $envVariable in your env configuration to enable the shared map widget.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (hasDartKey) ...[
              const SizedBox(height: 8),
              Text(
                'The native $platformLabel Maps key is still missing or using a placeholder value.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _resolveConfiguredEnvVariable() {
    try {
      return Platform.isIOS
          ? AppConfig.googleMapsApiKeyIOS
          : AppConfig.googleMapsApiKeyAndroid;
    } catch (_) {
      return '';
    }
  }
}
