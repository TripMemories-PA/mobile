import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/monument/model/response/poi/poi.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/position.dart';
import 'custom_card.dart';
import 'search_bar_custom.dart';

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
  BitmapDescriptor selectedMarkerIcon = BitmapDescriptor.defaultMarker;
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
    getBytesFromAsset('assets/images/selected_map_pin.png', 150).then((value) {
      setState(() {
        if (value != null) {
          selectedMarkerIcon = BitmapDescriptor.fromBytes(value);
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
                icon: selectedMarkerId == markerId
                    ? selectedMarkerIcon
                    : markerIcon,
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
                EasyDebounce.debounce('search_map_monuments', Durations.medium1,
                    () async {
                  final Position position = await _getPosition();
                  _getNewMonuments(position);
                });
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
                print("j'ai tapé sur la map");
                setState(() {
                  selectedMarkerId = null;
                  selectedPoi = null;
                });
              },
            ),
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: SearchOnMap(
                  onMonumentSelected: (Poi poi) {
                    setState(() {
                      final String lat = poi.latitude;
                      final double latitude = double.parse(lat);
                      final String lng = poi.longitude;
                      final double longitude = double.parse(lng);
                      final MarkerId markerId = MarkerId(poi.id.toString());
                      final Marker marker = Marker(
                        icon: selectedMarkerIcon,
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
                      selectedPoi = poi;
                      selectedMarkerId = markerId;
                      mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(latitude, longitude),
                          15,
                        ),
                      );
                    });
                  },
                ),
              ),
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

  Future<Position> _getPosition() async {
    final LatLngBounds bounds = await mapController.getVisibleRegion();
    final LatLng southwest = bounds.southwest;
    final LatLng northeast = bounds.northeast;
    final Position position = Position(
      swLat: southwest.latitude,
      swLng: southwest.longitude,
      neLat: northeast.latitude,
      neLng: northeast.longitude,
    );
    return position;
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
              color: Theme.of(context).colorScheme.surface,
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

class SearchOnMap extends HookWidget {
  const SearchOnMap({super.key, required this.onMonumentSelected});

  final Function onMonumentSelected;

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = useTextEditingController();
    final searching = useState(false);
    final searchContent = useState('');
    final ScrollController monumentsScrollController = useScrollController();
    useEffect(
      () {
        void createScrollListener() {
          if (monumentsScrollController.position.atEdge) {
            if (monumentsScrollController.position.pixels != 0) {
              context.read<MonumentBloc>().add(
                    GetMonumentsEvent(
                      searchingCriteria: searchContent.value,
                    ),
                  );
            }
          }
        }

        monumentsScrollController.addListener(createScrollListener);
        return () =>
            monumentsScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.90,
      height: searchContent.value.isNotEmpty
          ? MediaQuery.of(context).size.height * 0.4
          : 50,
      child: Column(
        children: [
          SearchBarCustom(
            searchController: searchController,
            context: context,
            searching: searching,
            searchContent: searchContent,
            onSearch: (value) {
              // TODO(nono): le is refresh wipe les markers il faut créer un évent spécial map search
              context.read<MonumentBloc>().add(
                    GetMonumentsEvent(
                      isRefresh: true,
                      searchingCriteria: value,
                    ),
                  );
            },
          ),
          if (searchContent.value.isNotEmpty)
            Column(
              children: [
                10.ph,
                BlocBuilder<MonumentBloc, MonumentState>(
                  builder: (context, state) {
                    if (state.status == MonumentStatus.error) {
                      return _buildErrorWidget(context);
                    } else if (state.status == MonumentStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.33,
                        child: SingleChildScrollView(
                          controller: monumentsScrollController,
                          child: Column(
                            children: [
                              ...state.monuments.map(
                                (Poi poi) => GestureDetector(
                                  onTap: () {
                                    searchContent.value = '';
                                    searchController.clear();
                                    onMonumentSelected(poi);
                                  },
                                  child: CustomCard(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    height: 50,
                                    content: Text(
                                      poi.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: state.searchMonumentsHasMoreMonuments
                                    ? (state.searchingMonumentByNameStatus ==
                                            MonumentStatus.loading
                                        ? SpinKitThreeBounce(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            size: 20,
                                          )
                                        : (state.status == MonumentStatus.error
                                            ? _buildErrorWidget(context)
                                            : const SizedBox.shrink()))
                                    : Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                            StringConstants().noMoreMonuments),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => {
            context.read<MonumentBloc>().add(
                  GetMonumentsEvent(
                    isRefresh: true,
                    searchingCriteria: '',
                  ),
                ),
          },
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }
}
