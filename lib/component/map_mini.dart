import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../object/map_style.dart';
import '../object/marker_icons_custom.dart';
import '../object/poi/poi.dart';

class MiniMap extends StatefulWidget {
  const MiniMap({
    super.key,
    required this.poi,
    this.width,
    this.height,
  });

  final Poi poi;
  final double? width;
  final double? height;

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildGoogleMap(),
    );
  }

  GoogleMap _buildGoogleMap() {
    final String lat = widget.poi.latitude;
    final double latitude = double.parse(lat);
    final String lng = widget.poi.longitude;
    final double longitude = double.parse(lng);
    final Marker marker = Marker(
      icon: MarkerIconsCustom.getMarkerIcon(widget.poi.type.id, true),
      markerId: MarkerId(widget.poi.id.toString()),
      position: LatLng(latitude, longitude),
    );
    final List<Marker> markers = [marker];
    final LatLng center = LatLng(latitude, longitude);

    return GoogleMap(
      zoomGesturesEnabled: false,
      scrollGesturesEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 11.0,
      ),
      markers: markers.toSet(),
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        // ignore: deprecated_member_use
        mapController.setMapStyle(MapStyle.style);
      },
    );
  }
}