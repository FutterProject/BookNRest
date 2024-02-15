import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ShowMap extends StatefulWidget {
  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  // static const LatLng centerMap = const LatLng(12.866065, 100.896632);
  // static const LatLng centerMap = const LatLng(37.421975, -122.084016);
  static const LatLng centerMap =
      const LatLng(13.118685137188292, 100.92146253209525); // 26 building
  CameraPosition cameraPosition = CameraPosition(
    target: centerMap,
    zoom: 16.0,
  );
  late LocationData currentLocation;
  // late CameraPosition cameraPositionMe;

  @override
  void initState() {
    super.initState();
    findLocation();
  }

  Future<void> findLocation() async {
    currentLocation = (await locationData())!;
    print(
        'Lat = ${currentLocation.latitude}, Long = ${currentLocation.longitude}');
    // cameraPosition = CameraPosition(
    //     target: LatLng(double.parse(currentLocation.latitude.toString()),
    //         double.parse(currentLocation.longitude.toString())),
    //     zoom: 16.0);
  }

  Future<LocationData?> locationData() async {
    var location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission Denied');
      }
      return null;
    }
  }

  Widget myMap() {
    return GoogleMap(
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      minMaxZoomPreference: MinMaxZoomPreference(15, 80),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      mapType: MapType.normal,
      // mapType: MapType.terrain,
      initialCameraPosition: cameraPosition,
      onMapCreated: (GoogleMapController googleMapController) {},
      markers: ewtcMarker(),
    );
  }

  Set<Marker> ewtcMarker() {
    return <Marker>[Marker(position: centerMap, markerId: MarkerId('idEWTC'))]
        .toSet();
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: 400,
            width: 400,
            child: myMap(),
          ),
        ),
      ),
    );
  }
}
