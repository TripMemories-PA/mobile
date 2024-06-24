import 'package:flutter/services.dart';

class MapStyle {
  factory MapStyle() {
    return _instance;
  }

  MapStyle._internal();
  static final MapStyle _instance = MapStyle._internal();

  String? _mapStyleLightTheme;

  static Future<void> initialize() async {
    _instance._mapStyleLightTheme = await _loadMapStyle();
  }

  static Future<String> _loadMapStyle() async {
    return rootBundle.loadString('assets/map_styles/map_style.json');
  }

  static String? get style => _instance._mapStyleLightTheme;
}
