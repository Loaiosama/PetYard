import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petowner_frontend/features/sitting/data/model/sitting_request%20.dart';

class SetLocation extends StatefulWidget {
  final Function(Location) onLocationSelected;
  const SetLocation({super.key, required this.onLocationSelected});

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  final Completer<GoogleMapController> _mapcontroller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(30.044420, 31.235712), zoom: 14);

  GoogleMapController? gmc;
  List<Marker> markers = [
    //Marker(markerId: MarkerId("1"), position: LatLng(30.044420, 31.235712)),
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500.h,
      width: double.infinity,
      child: GoogleMap(
        onTap: (LatLng latlng) {
          print("----------");
          print(latlng.latitude);
          print(latlng.longitude);
          print("-------------");
          markers.add(Marker(
              markerId: const MarkerId("1"),
              position: LatLng(latlng.latitude, latlng.longitude)));

          widget.onLocationSelected(Location(
            x: latlng.latitude,
            y: latlng.longitude,
          ));

          setState(() {});
        },
        markers: markers.toSet(),
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          gmc = controller;
        },
      ),
    );
  }
}
