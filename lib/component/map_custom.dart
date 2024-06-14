import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/poi/model/response/poi/poi.dart';
import '../constants/route_name.dart';

final Completer<GoogleMapController> _controller = Completer();

class MapCustom extends StatefulWidget {
  const MapCustom({super.key, required this.pois,});

  final List<Poi> pois;

  @override
  State<MapCustom> createState() => _MapCustomState();
}

class _MapCustomState extends State<MapCustom> {
  late GoogleMapController mapController;
  String? _mapStyleString;
  GoogleMap? myMap;
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
    getBytesFromAsset('assets/images/paris.png', 100).then((value) {
      setState(() {
        if (value != null) {
          markerIcon = BitmapDescriptor.fromBytes(value);
        }
        buildGoogleMap();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myMap ?? const Center(child: CircularProgressIndicator()),
    );
  }

  void buildGoogleMap() {
    final List<Marker> markers = [];
    for(final Poi poi in widget.pois) {
      try {
        String lat = poi.latitude;
        double latitude = double.parse(lat);
        String lng = poi.longitude;
        double longitude = double.parse(lng);
        markers.add(Marker(
          onTap: () {
            context.go('${RouteName.monumentPage}/${poi.id}', extra: poi,);
          },
          icon: markerIcon,
          markerId: MarkerId(poi.id.toString()),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: poi.name,
            snippet: poi.description,
          ),
        ),);
      } catch (e) {
        print(e);
      };
      setState(() {
        myMap = GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: markers.toSet(),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _controller.future.then((value) {
              mapController = value;
              // ignore: deprecated_member_use
              mapController.setMapStyle(_mapStyleString);
            });
          },
        );
      });
      }

  }
}
