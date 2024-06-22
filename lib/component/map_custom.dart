import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/monument/model/response/poi/poi.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../constants/route_name.dart';
import '../num_extensions.dart';
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
  Poi? selectedPoi;
  late GoogleMapController mapController;
  String? _mapStyleString;
  final LatLng _center = const LatLng(48.84922330209508, 2.389781701197292);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  MarkerId? selectedMarkerId;

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
                onTap: () {
                  setState(() {
                    selectedPoi = poi;
                    selectedMarkerId = markerId;
                  });
                },
              );
              markers[markerId] = marker;
            }
          });
        },
        child: Stack(
          children: [
            GoogleMap(
              mapToolbarEnabled: false,
              onCameraIdle: () async {
                final LatLngBounds bounds =
                    await mapController.getVisibleRegion();
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
              onTap: (LatLng position) {
                setState(() {
                  selectedMarkerId = null;
                  selectedPoi = null;
                });
              },
            ),
            if (selectedPoi != null) _buildMonumentPopupCard(context),
            if (selectedPoi != null)
              Positioned(
                right: 10,
                bottom: 170,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      selectedMarkerId = null;
                      selectedPoi = null;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Positioned _buildMonumentPopupCard(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30,
      child: Center(
        child: GestureDetector(
          onTap: () {
            context.push(
              '${RouteName.monumentPage}/${selectedPoi?.id}',
              extra: selectedPoi,
            );
          },
          child: Container(
            width: 370,
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                15.pw,
                SizedBox(
                  height: 140,
                  width: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      selectedPoi?.cover.url ?? '',
                      loadingBuilder: (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                      },
                      errorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        return const Icon(
                          CupertinoIcons.exclamationmark_triangle,
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                15.pw,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      15.ph,
                      Text(
                        selectedPoi?.city ?? 'Pas de ville',
                        style: TextStyle(
                          height: 1,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      5.ph,
                      Text(
                        selectedPoi?.name ?? 'Pas de nom',
                        style: TextStyle(
                          height: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: _manageFontSize(selectedPoi!.name),
                        ),
                      ),
                      5.ph,
                      Text(
                        selectedPoi?.address ?? "Pas d'adresse",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${selectedPoi?.zipCode}',
                      ),
                      10.ph,
                      // TODO(nono): mettre la bonne note
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBar(
                            glow: false,
                            initialRating: 2.5,
                            itemPadding: const EdgeInsets.symmetric(
                              horizontal: 1.5,
                            ),
                            minRating: 1,
                            maxRating: 5,
                            updateOnDrag: true,
                            allowHalfRating: true,
                            itemSize: 14,
                            ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              half: Icon(
                                Icons.star_half,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              empty: Icon(
                                Icons.star_border_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            onRatingUpdate: (double value) {},
                          ),
                          Text(
                            '(1245 avis)',
                            style: TextStyle(
                              fontSize: 9,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      15.ph,
                    ],
                  ),
                ),
                15.pw,
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _manageFontSize(String text) {
    if (text.length > 20) {
      return 15;
    } else {
      if (text.length > 15) {
        return 20;
      } else {
        return 23;
      }
    }
  }

  void _getNewMonuments(Position position) {
    widget.monumentBloc.add(
      GetMonumentsOnMapEvent(
        position: position,
      ),
    );
  }
}
