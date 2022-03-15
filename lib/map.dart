import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:movii/home_controller.dart';
import 'package:movii/user.dart';

const double CAMERA_ZOOM = 15;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
late UserModel usuario;

class MyMap extends StatelessWidget {
  const MyMap({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movi IFPI',
      home: MapSample(user),
    );
  }
}

class MapSample extends StatefulWidget {
  MapSample(this.user);
  final UserModel user;
  @override
  State<MapSample> createState() => MapSampleState(user);
}

class MapSampleState extends State<MapSample> {
  HomeController controller_user = Modular.get();

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  BitmapDescriptor paradaIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor busIcon = BitmapDescriptor.defaultMarker;
  LocationData? currentLocation = null;
  double? busLatitude = null;
  double? busLongitude = null;
  Location location = Location.instance;

  MapSampleState(this.user);
  final UserModel user;
  @override
  void initState() {
    super.initState();
    setDisplayIcons();
    location = new Location();
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap();
      if (user.carro) {
        savePosition();
      }else{
        controller_user.getCarro(user.campus_sigla);
        busLatitude = double.parse(controller_user.carro.latitude);
        busLongitude = double.parse(controller_user.carro.longitude);
      }
    });
  }

  void showPinsOnMap() {   // get a LatLng for the source location
    // from the LocationData currentLocation object
    var parada1 = LatLng(-10.430337, -45.174108);   // get a LatLng out of the LocationData object
    var parada2 = LatLng(-10.435572, -45.178832 );
    var parada3 = LatLng(-10.438362,-45.1716483);// add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('parada1'),
        position: parada1,
        icon: paradaIcon
    ));   // destination pin
    _markers.add(Marker(
        markerId: MarkerId('parada2'),
        position: parada2,
        icon: paradaIcon
    ));
    _markers.add(Marker(
        markerId: MarkerId('parada3'),
        position: parada3,
        icon: paradaIcon
    ));   // set the route lines on the map from source to destination
// set the route lines on the map from source to destination
    // for more info follow this tutorial
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(double.parse(currentLocation!.latitude.toString()),
        double.parse(currentLocation!.longitude.toString())),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(cPosition)
    );   // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      if (user.carro) {
        _markers.add(Marker(
            markerId: MarkerId('bus'),
            position: LatLng(double.parse(currentLocation!.latitude.toString()),
                double.parse(currentLocation!.longitude.toString())),
            icon: busIcon
        ));
      }else{
        _markers.add(Marker(
            markerId: MarkerId('bus'),
            position: LatLng(busLatitude!, busLongitude!),
            icon: busIcon
        ));// updated position
      }
    });
  }

  void setDisplayIcons() async {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/bus-stop.png').then((onValue) {
            paradaIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/ico_bus_loc.png').then((onValue) {
            busIcon = onValue;
    });
  }
  void setInitialLocation() async {   // set the initial location by pulling the user's
    currentLocation = await location.getLocation();
  }

  void savePosition() async
     {
      controller_user.setEmail(user.email);
      controller_user.setLatitude(currentLocation!.latitude.toString());
      controller_user.setLongitude(currentLocation!.longitude.toString());
      controller_user.savePosition();
    }


  @override
  Widget build(BuildContext context) {   CameraPosition initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(0.0,0.0)
  );
  if (currentLocation != null) {
    initialCameraPosition = CameraPosition(
        target: LatLng(double.parse(currentLocation!.latitude.toString()),
            double.parse(currentLocation!.longitude.toString())),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING
    );
  }
    return  Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: _markers,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            showPinsOnMap();
          });
        },
        myLocationEnabled: true,
      ),
    );
  }
}



