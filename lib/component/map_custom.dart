import 'dart:async';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;

import '../api/dio.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/map_style.dart';
import '../object/marker_icons_custom.dart';
import '../object/poi/poi.dart';
import '../object/position.dart';
import '../object/profile.dart';
import 'search_bar_custom.dart';

class MapCustom extends StatefulWidget {
  const MapCustom({
    super.key,
    required this.monumentBloc,
    this.profileBloc,
  });

  final MonumentBloc monumentBloc;
  final ProfileBloc? profileBloc;

  @override
  State<MapCustom> createState() => _MapCustomState();
}

class _MapCustomState extends State<MapCustom> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> friendsMarkers = <MarkerId, Marker>{};
  Poi? selectedPoi;
  Profile? selectedProfile;
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(48.84922330209508, 2.389781701197292);
  MarkerId? selectedMarkerId;
  MarkerId? selectedFriendMarkerId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileBloc? profileBloc = widget.profileBloc;
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<MonumentBloc, MonumentState>(
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
                        selectedProfile = null;
                        selectedFriendMarkerId = null;
                        selectedPoi = poi;
                        selectedMarkerId = markerId;
                      });
                    },
                  );
                  markers[markerId] = marker;
                }
              });
            },
          ),
          if (profileBloc != null)
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) async {
                final Map<MarkerId, Marker> newFriendsMarkers = {};

                for (final Profile profile in state.friends.data) {
                  final double? latitude = profile.latitude;
                  final double? longitude = profile.longitude;
                  if (latitude == null || longitude == null) {
                    continue;
                  } else {
                    final MarkerId markerId = MarkerId(profile.id.toString());
                    final BitmapDescriptor userIcon;
                    final String? url = profile.avatar?.url;
                    if (url == null) {
                      userIcon = MarkerIconsCustom.getMarkerIcon(
                        MarkerIconType.friend,
                        selectedFriendMarkerId == markerId,
                      );
                    } else {
                      const int size = 100;
                      final Uint8List imageData = await _downloadImage(url);
                      final img.Image? originalImage =
                          img.decodeImage(imageData);
                      if (originalImage == null) {
                        throw Exception('Failed to decode image');
                      }

                      final img.Image resizedImage = img.copyResize(
                        originalImage,
                        width: size,
                        height: size,
                      );

                      final Uint8List resizedImageData =
                          Uint8List.fromList(img.encodePng(resizedImage));
                      // ignore: deprecated_member_use
                      userIcon = BitmapDescriptor.fromBytes(resizedImageData);
                    }
                    final Marker marker = Marker(
                      markerId: markerId,
                      position: LatLng(latitude, longitude),
                      icon: userIcon,
                      onTap: () {
                        setState(() {
                          selectedPoi = null;
                          selectedMarkerId = null;
                          selectedProfile = profile;
                          selectedFriendMarkerId = markerId;
                        });
                      },
                    );
                    newFriendsMarkers[markerId] = marker;
                  }
                }

                setState(() {
                  friendsMarkers = newFriendsMarkers;
                });
              },
            ),
        ],
        child: Stack(
          children: [
            _buildGoogleMap(),
            _buildSearchMonumentPart(),
            if (selectedPoi != null) _buildMonumentPopupCard(context),
            if (selectedProfile != null) _buildFriendPopupCard(context),
            if (selectedPoi != null)
              Positioned(
                right: 10,
                bottom: 210,
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
            if (selectedProfile != null)
              Positioned(
                right: 10,
                bottom: 150,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _removeSelectedIconOnFriend();
                      selectedFriendMarkerId = null;
                      selectedProfile = null;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.surface,
        mini: true,
        onPressed: _centerCamera,
        child: Icon(
          Icons.my_location,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }

  Future<Uint8List> _downloadImage(String url) async {
    try {
      final response = await DioClient.instance.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data);
    } catch (e) {
      throw Exception('Failed to download image: $e');
    }
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

  void _removeSelectedIconOnFriend() {
    final Profile? tmpSelectedProfile = selectedProfile;
    final MarkerId? tmpSelectedFriendMarkerId = selectedFriendMarkerId;
    if (tmpSelectedFriendMarkerId != null && tmpSelectedProfile != null) {
      final double? latitude = tmpSelectedProfile.latitude;
      final double? longitude = tmpSelectedProfile.longitude;
      if (latitude != null && longitude != null) {
        friendsMarkers[tmpSelectedFriendMarkerId] = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
          markerId: tmpSelectedFriendMarkerId,
          position: LatLng(latitude, longitude),
          onTap: () {
            setState(() {
              selectedProfile = null;
              selectedFriendMarkerId = null;
            });
          },
        );
      }
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

  Future<void> _centerCamera() async {
    final Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(currentPosition.latitude, currentPosition.longitude),
      ),
    );
  }

  GoogleMap _buildGoogleMap() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onCameraIdle: () async {
        EasyDebounce.debounce('search_map_monuments', Durations.medium1,
            () async {
          final PositionDataCustom position = await _getPosition();
          _getNewMonuments(position);
          _getFriends(position);
        });
      },
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
      markers: {
        ...markers.values,
        ...friendsMarkers.values,
      },
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

  Future<PositionDataCustom> _getPosition() async {
    final LatLngBounds bounds = await mapController.getVisibleRegion();
    final LatLng southwest = bounds.southwest;
    final LatLng northeast = bounds.northeast;
    final PositionDataCustom position = PositionDataCustom(
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
      bottom: 65,
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

  Positioned _buildFriendPopupCard(BuildContext context) {
    final Profile? selectedProfile = this.selectedProfile;
    if (selectedProfile == null) {
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
              '${RouteName.profilePage}/${selectedProfile.id}',
            );
          },
          child: Container(
            width: 370,
            height: 150,
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
                    child: selectedProfile.avatar != null
                        ? Image.network(
                            selectedProfile.avatar!.url,
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
                          )
                        : const Icon(
                            CupertinoIcons.person,
                            size: 150,
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
                        selectedProfile.username,
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
                        selectedProfile.lastname ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      5.ph,
                      AutoSizeText(
                        selectedProfile.firstname ?? '',
                        maxLines: 2,
                      ),
                      Text(
                        '${selectedProfile.poisCount?.toString() ?? 0} ${StringConstants().visitedBuildings}',
                      ),
                      10.ph,
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

  void _getNewMonuments(PositionDataCustom position) {
    widget.monumentBloc.add(
      GetMonumentsOnMapEvent(
        position: position,
      ),
    );
  }

  void _getFriends(PositionDataCustom position) {
    final ProfileBloc? profileBloc = widget.profileBloc;
    if (profileBloc != null) {
      profileBloc.add(
        GetFriendsEvent(
          position: position,
          isOnMap: true,
        ),
      );
    }
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
