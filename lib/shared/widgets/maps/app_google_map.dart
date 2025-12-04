import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/config/app_config.dart';

class AppGoogleMap extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double? zoom;
  final Set<Marker>? markers;
  final Set<Polyline>? polylines;
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
    this.polylines,
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

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(
        widget.latitude ?? 0.0,
        widget.longitude ?? 0.0,
      ),
      zoom: widget.zoom ?? 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final apiKey = AppConfig.googleMapsApiKey;
    
    if (apiKey.isEmpty) {
      return const Center(
        child: Text('Google Maps API Key not configured'),
      );
    }

    return GoogleMap(
      initialCameraPosition: _initialCameraPosition,
      markers: widget.markers ?? {},
      polylines: widget.polylines ?? {},
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
                    (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
                    (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
                  );
                  widget.onCameraIdle!(CameraPosition(target: center, zoom: 14.0));
                });
              }
            }
          : null,
      onLongPress: widget.onLongPress,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> animateToLocation(double latitude, double longitude, {double? zoom}) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(latitude, longitude),
          zoom ?? widget.zoom ?? 14.0,
        ),
      );
    }
  }

  Future<void> setMapType(MapType mapType) async {
    // Note: GoogleMapController doesn't have setMapType method
    // Map type should be controlled via the widget's mapType property
    // This method is kept for API compatibility but doesn't perform any action
  }
}

