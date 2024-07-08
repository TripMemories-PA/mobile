import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/my_colors.dart';
import '../city.dart';
import '../marker_icons_custom.dart';
import '../uploaded_file.dart';
import 'poi_icon.dart';
import 'poi_type.dart';

class Poi {
  Poi({
    required this.id,
    required this.name,
    this.description,
    this.coverId,
    required this.typeId,
    required this.latitude,
    required this.longitude,
    this.city,
    this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.cover,
    required this.type,
    this.postsCount,
    this.averageNote,
  });

  factory Poi.fromJson(Map<String, dynamic> json) {
    return Poi(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      coverId: json['coverId'] as int?,
      typeId: json['typeId'] as int,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      cover: UploadFile.fromJson(json['cover'] as Map<String, dynamic>),
      type: PoiType.fromJson(json['type'] as Map<String, dynamic>),
      postsCount: json['postsCount'] as int?,
      averageNote: json['averageNote'] as num?,
    );
  }

  Poi copyWith({
    int? id,
    String? name,
    String? description,
    int? coverId,
    int? typeId,
    String? latitude,
    String? longitude,
    City? city,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
    UploadFile? cover,
    PoiType? type,
    int? postsCount,
    num? averageNote,
  }) {
    return Poi(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverId: coverId ?? this.coverId,
      typeId: typeId ?? this.typeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cover: cover ?? this.cover,
      type: type ?? this.type,
      postsCount: postsCount ?? this.postsCount,
      averageNote: averageNote ?? this.averageNote,
    );
  }

  Icon get icon {
    switch (typeId) {
      case 1:
        return Icon(
          PoiIcon.museum,
          color: MyColors.purple,
        );
      case 2:
        return Icon(
          PoiIcon.park,
          color: MyColors.success,
        );
      case 3:
        return Icon(
          PoiIcon.monument,
          color: MyColors.darkGrey,
        );
      case 4:
        return Icon(
          PoiIcon.religious,
          color: MyColors.darkBlue,
        );
      default:
        return Icon(PoiIcon.museum, color: MyColors.darkGrey);
    }
  }

  BitmapDescriptor get markerIcon {
    return MarkerIconsCustom.getMarkerIcon(
      MarkerIconType.getFromCode(typeId),
      false,
    );
  }

  BitmapDescriptor get selectedMarkerIcon {
    return MarkerIconsCustom.getMarkerIcon(
      MarkerIconType.getFromCode(typeId),
      true,
    );
  }

  final int id;
  final String name;
  final String? description;
  final int? coverId;
  final int typeId;
  final String latitude;
  final String longitude;
  final City? city;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UploadFile cover;
  final PoiType type;
  final int? postsCount;
  final num? averageNote;
}
