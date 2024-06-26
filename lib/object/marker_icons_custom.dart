import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIconsCustom {
  factory MarkerIconsCustom() {
    return _instance;
  }

  MarkerIconsCustom._internal();
  static final MarkerIconsCustom _instance = MarkerIconsCustom._internal();

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor museumMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedMuseumMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor churchMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedChurchMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor gardenMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedGardenMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor monumentMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedMonumentMarkerIcon = BitmapDescriptor.defaultMarker;

  static Future<void> initialize() async {
    await _instance._initializeAssets();
  }

  Future<void> _initializeAssets() async {
    museumMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_museum.png', 100);
    selectedMuseumMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_museum_selected.png', 150);
    churchMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_church.png', 100);
    selectedChurchMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_church_selected.png', 150);
    gardenMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_garden.png', 100);
    selectedGardenMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_garden_selected.png', 150);
    monumentMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_monument.png', 100);
    selectedMonumentMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_monument_selected.png', 150);
  }

  Future<BitmapDescriptor> _loadMarkerIcon(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  static BitmapDescriptor getMarkerIcon(int type, bool isSelected) {
    switch (type) {
      case 1:
        return isSelected
            ? _instance.selectedMuseumMarkerIcon
            : _instance.museumMarkerIcon;
      case 2:
        return isSelected
            ? _instance.selectedGardenMarkerIcon
            : _instance.gardenMarkerIcon;
      case 3  :
        return isSelected
            ? _instance.selectedMonumentMarkerIcon
            : _instance.monumentMarkerIcon;
      case 4:
        return isSelected
            ? _instance.selectedChurchMarkerIcon
            : _instance.churchMarkerIcon;
      default:
        return isSelected ? _instance.selectedMarkerIcon : _instance.markerIcon;
    }
  }
}
