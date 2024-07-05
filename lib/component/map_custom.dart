import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../bloc/monument_bloc/monument_bloc.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/map_style.dart';
import '../object/poi/poi.dart';
import '../object/position.dart';
import 'search_bar_custom.dart';

class MapCustom extends StatefulWidget {
  const MapCustom({
    super.key,
    required this.monumentBloc,
  });

  final MonumentBloc monumentBloc;

  @override
  State<MapCustom> createState() => _MapCustomState();
}

class _MapCustomState extends State<MapCustom> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Poi? selectedPoi;
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(48.84922330209508, 2.389781701197292);
  MarkerId? selectedMarkerId;

  @override
  void initState() {
    super.initState();
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
                    ? poi.selectedMarkerIcon
                    : poi.markerIcon,
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
            _buildGoogleMap(),
            _buildSearchMonumentPart(),
            if (selectedPoi != null) _buildMonumentPopupCard(context),
            if (selectedPoi != null)
              Positioned(
                right: 10,
                bottom: 170,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _removeSelectedIconOnPoi();
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

  void _removeSelectedIconOnPoi() {
    final Poi? tmpSelectedPoi = selectedPoi;
    final MarkerId? tmpSelectedMarkerId = selectedMarkerId;
    if (tmpSelectedMarkerId != null && tmpSelectedPoi != null) {
      final double latitude = double.parse(tmpSelectedPoi.latitude);
      final double longitude = double.parse(tmpSelectedPoi.longitude);
      markers[tmpSelectedMarkerId] = Marker(
        icon: tmpSelectedPoi.markerIcon,
        markerId: tmpSelectedMarkerId,
        position: LatLng(latitude, longitude),
        onTap: () {
          setState(() {
            selectedPoi = null;
            selectedMarkerId = null;
          });
        },
      );
    }
  }

  Positioned _buildSearchMonumentPart() {
    return Positioned(
      top: 30,
      left: 0,
      right: 0,
      child: Center(
        child: _SearchOnMap(
          onMonumentSelected: (Poi poi) {
            setState(() {
              final String lat = poi.latitude;
              final double latitude = double.parse(lat);
              final String lng = poi.longitude;
              final double longitude = double.parse(lng);
              final MarkerId markerId = MarkerId(poi.id.toString());
              final Marker marker = Marker(
                icon: poi.selectedMarkerIcon,
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
    );
  }

  GoogleMap _buildGoogleMap() {
    return GoogleMap(
      myLocationButtonEnabled: false,
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
        mapController = controller;
        // ignore: deprecated_member_use
        mapController.setMapStyle(MapStyle.style);
      },
      onTap: (LatLng position) {
        setState(() {
          _removeSelectedIconOnPoi();
          selectedMarkerId = null;
          selectedPoi = null;
        });
      },
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
    final Poi? selectedPoi = this.selectedPoi;
    if (selectedPoi == null) {
      return const Positioned(
        left: 0,
        right: 0,
        bottom: 30,
        child: Center(
          child: SizedBox.shrink(),
        ),
      );
    }
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30,
      child: Center(
        child: GestureDetector(
          onTap: () {
            context.push(
              '${RouteName.monumentPage}/${selectedPoi.id}',
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
                      selectedPoi.cover.url,
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
                        selectedPoi.city?.name ?? '',
                        style: TextStyle(
                          height: 1,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      5.ph,
                      AutoSizeText(
                        selectedPoi.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      5.ph,
                      AutoSizeText(
                        selectedPoi.address ?? '',
                        maxLines: 2,
                      ),
                      Text(
                        '${selectedPoi.city?.zipCode}',
                      ),
                      10.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBar(
                            glow: false,
                            initialRating:
                                selectedPoi.averageNote?.toDouble() ?? 0,
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
                            '(${selectedPoi.postsCount} ${StringConstants().reviews}',
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

  void _getNewMonuments(Position position) {
    widget.monumentBloc.add(
      GetMonumentsOnMapEvent(
        position: position,
      ),
    );
  }
}

class _SearchOnMap extends HookWidget {
  const _SearchOnMap({required this.onMonumentSelected});

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
            hintText: StringConstants().searchMonuments,
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
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: BlocBuilder<MonumentBloc, MonumentState>(
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
                                  (Poi poi) => Builder(
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () {
                                          searchContent.value = '';
                                          searchController.clear();
                                          onMonumentSelected(poi);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15.0,
                                            horizontal: 10.0,
                                          ),
                                          child: Row(
                                            children: [
                                              15.pw,
                                              poi.icon,
                                              15.pw,
                                              Expanded(
                                                child: Text(
                                                  poi.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
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
                                          : (state.status ==
                                                  MonumentStatus.error
                                              ? _buildErrorWidget(context)
                                              : const SizedBox.shrink()))
                                      : SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            StringConstants().noMoreMonuments,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                ),
                                8.ph,
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
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
