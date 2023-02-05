import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    context.read<MainScreenCubit>().initParams();
    getCurrentLocation();

    super.initState();
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

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.mapApp.tr()),
          centerTitle: true,
        ),
        drawer: NavigationBarDrawer(onTap: () async {
          await context.read<MainScreenCubit>().onSignOut();
          Navigator.of(context).pushNamed('/welcome');
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

        final marker = Marker(
          markerId: MarkerId(markerId),
          position: LatLng(
            double.parse(latitude),
            double.parse(longitude),
          ),
          onTap: () async {
            final userInfo = await context
                .read<MainScreenCubit>()
                .onTakeSelectedUserInfo(markerId);

            showInfoDialog(
              context: context,
              avatar: userInfo.avatarUrl,
              name: userInfo.name,
              email: userInfo.email,
            );
          },
        );
        listMarker.add(marker);
      });
    }
  }
}
