import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/monument/model/response/poi/poi.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../constants/route_name.dart';
import '../object/position.dart';

final Completer<GoogleMapController> _controller = Completer();

class MapCustom extends StatefulWidget {
  const MapCustom({
    super.key,
    required this.pois,
    required this.monumentBloc,
  });

  final List<Poi> pois;
  final MonumentBloc monumentBloc;

  @override
  State<MapCustom> createState() => _MapCustomState();
}

class _MapCustomState extends State<MapCustom> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late GoogleMapController mapController;
  String? _mapStyleString;
  final LatLng _center = const LatLng(48.84922330209508, 2.389781701197292);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui
        .instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_styles/map_style.json').then((string) {
      setState(() {
        _mapStyleString = string;
      });
    });
    getBytesFromAsset('assets/images/map_pin.png', 100).then((value) {
      setState(() {
        if (value != null) {
          markerIcon = BitmapDescriptor.fromBytes(value);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MonumentBloc, MonumentState>(
        listener: (context, state) {
          setState(() {
            markers = <MarkerId, Marker>{};
            for (final Poi poi in state.monuments) {
              final String lat = poi.latitude;
              final double latitude = double.parse(lat);
              final String lng = poi.longitude;
              final double longitude = double.parse(lng);
              final MarkerId markerId = MarkerId(poi.id.toString());
              final Marker marker = Marker(
                icon: markerIcon,
                markerId: MarkerId(poi.id.toString()),
                position: LatLng(latitude, longitude),
                infoWindow: InfoWindow(
                  title: poi.name,
                  snippet: 'Cliquez pour plus de détails',
                  onTap: () {
                    context.push(
                      '${RouteName.monumentPage}/${poi.id}',
                      extra: poi,
                    );
                  },
                ),
              );
              markers[markerId] = marker;
            }
          });
        },
        child: GoogleMap(
          onCameraIdle: () async {
            final LatLngBounds bounds = await mapController.getVisibleRegion();
            final LatLng southwest = bounds.southwest;
            final LatLng northeast = bounds.northeast;
            final Position position = Position(
              swLat: southwest.latitude,
              swLng: southwest.longitude,
              neLat: northeast.latitude,
              neLng: northeast.longitude,
            );
            _getNewMonuments(position);
          },
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: Set<Marker>.of(markers.values),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _controller.future.then((value) {
              mapController = value;
              // ignore: deprecated_member_use
              mapController.setMapStyle(_mapStyleString);
            });
          },
        ),
      ),
    );
  }

  void _getNewMonuments(Position position) {
    widget.monumentBloc.add(
      GetMonumentsOnMapEvent(
        position: position,
      ),
    );
  }
}
