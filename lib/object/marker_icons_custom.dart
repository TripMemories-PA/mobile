import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
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
  BitmapDescriptor friendMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedFriendMarkerIcon = BitmapDescriptor.defaultMarker;

  static Future<void> initialize() async {
    await _instance._initializeAssets();
  }

  Future<void> _initializeAssets() async {
    museumMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_museum.png', 100);
    selectedMuseumMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_museum_selected.png', 125);
    churchMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_church.png', 100);
    selectedChurchMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_church_selected.png', 125);
    gardenMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_garden.png', 100);
    selectedGardenMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_garden_selected.png', 125);
    monumentMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_monument.png', 100);
    selectedMonumentMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_monument_selected.png', 125);
    friendMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_friend.png', 100);
    selectedFriendMarkerIcon =
        await _loadMarkerIcon('assets/images/pin_friend_selected.png', 125);
  }

  Future<BitmapDescriptor> _loadMarkerIcon(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui
        .instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List? bytes =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))
            ?.buffer
            .asUint8List();
    if (bytes == null) {
      return BitmapDescriptor.defaultMarker;
    }
    return BitmapDescriptor.fromBytes(
      bytes,
      size: Size(width.toDouble(), width.toDouble()),
    );
  }

  static BitmapDescriptor getMarkerIcon(MarkerIconType type, bool isSelected) {
    if (type == MarkerIconType.museum) {
      return isSelected
          ? _instance.selectedMuseumMarkerIcon
          : _instance.museumMarkerIcon;
    } else if (type == MarkerIconType.garden) {
      return isSelected
          ? _instance.selectedGardenMarkerIcon
          : _instance.gardenMarkerIcon;
    } else if (type == MarkerIconType.monument) {
      return isSelected
          ? _instance.selectedMonumentMarkerIcon
          : _instance.monumentMarkerIcon;
    } else if (type == MarkerIconType.church) {
      return isSelected
          ? _instance.selectedChurchMarkerIcon
          : _instance.churchMarkerIcon;
    } else if (type == MarkerIconType.friend) {
      return isSelected
          ? _instance.selectedFriendMarkerIcon
          : _instance.friendMarkerIcon;
    } else {
      // Fallback case, though ideally this should never be reached
      return isSelected ? _instance.selectedMarkerIcon : _instance.markerIcon;
    }
  }
}

@immutable
class MarkerIconType {
  const MarkerIconType._(this.name);
  final String name;

  static const MarkerIconType museum = MarkerIconType._('museum');
  static const MarkerIconType garden = MarkerIconType._('garden');
  static const MarkerIconType monument = MarkerIconType._('monument');
  static const MarkerIconType church = MarkerIconType._('church');
  static const MarkerIconType friend = MarkerIconType._('friend');

  static MarkerIconType getFromCode(int code) {
    switch (code) {
      case 1:
        return museum;
      case 2:
        return garden;
      case 3:
        return monument;
      case 4:
        return church;
      case 5:
        return friend;
      default:
        return museum;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkerIconType &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'MarkerIconType{name: $name}';
}
