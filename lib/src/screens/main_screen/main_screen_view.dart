import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_app/src/app_resources/locale_keys.g.dart';
import 'package:map_app/src/screens/main_screen/main_screen_cubit.dart';
import 'package:map_app/src/screens/main_screen/main_screen_state.dart';
import 'package:map_app/src/widgets/dialog/info_dialog.dart';
import 'package:map_app/src/widgets/navigation_bar_drawer.dart';

final listMarker = <Marker>{};

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {
  LocationData? currentLocation;
  final Completer<GoogleMapController> _controller = Completer();
  String searchAdr = '';
  List<LatLng> polylineCoordinates = [];
  LatLng selectedUser = const LatLng(0, 0);
  Set<Polyline> polylines = <Polyline>{};

  @override
  void initState() {
    addPolylines();
    context.read<MainScreenCubit>().initParams();
    getCurrentLocation();

    super.initState();
  }

  void addPolylines() {
    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 6,
      ),
    );
  }

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
    });

    location.onLocationChanged.listen((newLocation) async {
      currentLocation = newLocation;
      setState(() {});
      updateLoction();
    });
  }

  void _myLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData? currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(
          currentLocation!.latitude!,
          currentLocation.longitude!,
        ),
        zoom: 14.0,
      ),
    ));
  }

  void updateLoction() {
    context.read<MainScreenCubit>().onChangeLocation(
        currentLocation!.latitude!.toString(),
        currentLocation!.longitude!.toString());
  }

  void takeRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyAZrqQcYnmLG4FlpKugIzkCFjR9VPsIptg',
        PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        PointLatLng(selectedUser.latitude, selectedUser.longitude));

    polylineCoordinates.clear();

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.mapApp.tr()),
          centerTitle: true,
        ),
        drawer: NavigationBarDrawer(onTap: () async {
          Navigator.of(context).pushNamed('/welcome');
          await context.read<MainScreenCubit>().onSignOut();
        }),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: FloatingActionButton(
              child: const Icon(Icons.location_on),
              onPressed: () {
                _myLocation();
              }),
        ),
        body: currentLocation == null
            ? const Center(
                child: Text('Loading...'),
              )
            : _buildMap());
  }

  Widget _buildMap() {
    return BlocBuilder<MainScreenCubit, MainScreenState>(
      builder: (context, state) {
        return StreamBuilder(
            stream: FirebaseDatabase.instance.ref('users/').onValue,
            builder: (context, snapshot) {
              _buildMarkerList(snapshot);

              return GoogleMap(
                  polylines: polylines,
                  initialCameraPosition: CameraPosition(
                    zoom: 14,
                    target: LatLng(
                      currentLocation!.latitude!,
                      currentLocation!.longitude!,
                    ),
                  ),
                  onMapCreated: (controller) =>
                      _controller.complete(controller),
                  markers: listMarker);
            });
      },
    );
  }

  void _buildMarkerList(AsyncSnapshot<DatabaseEvent> snapshot) {
    if (snapshot.data?.snapshot.value != null) {
      final data =
          Map<String, dynamic>.from(snapshot.data?.snapshot.value as Map);
      data.forEach((key, value) {
        final markerId = key;
        final latitude = value['latitude'];
        final longitude = value['longitude'];
        final markerColor = value['markerColor'];

        final marker = Marker(
          icon: _markerColor(markerColor),
          markerId: MarkerId(markerId),
          position: LatLng(
            double.parse(latitude),
            double.parse(longitude),
          ),
          onTap: () async {
            final userInfo = await context
                .read<MainScreenCubit>()
                .onTakeSelectedUserInfo(markerId);

            selectedUser = LatLng(
              double.parse(userInfo.latitude!),
              double.parse(userInfo.longitude!),
            );

            showInfoDialog(
                context: context,
                avatar: userInfo.avatarUrl,
                name: userInfo.name,
                email: userInfo.email,
                onPressed: () {
                  takeRoute();
                  Navigator.pop(context);
                },
                onCancel: () {
                  polylineCoordinates.clear();
                  Navigator.pop(context);
                });
          },
        );
        listMarker.add(marker);
      });
    }
  }

  BitmapDescriptor _markerColor(int color) {
    if (color == Colors.blue.value) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else if (color == Colors.orange.value) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    } else if (color == Colors.yellow.value) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    } else if (color == Colors.green.value) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else if (color == Colors.cyan.value) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }
}
