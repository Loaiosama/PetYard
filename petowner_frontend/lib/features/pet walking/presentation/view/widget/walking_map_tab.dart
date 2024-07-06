import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/pet%20walking/data/model/walking_request.dart';

class WalkingMapTab extends StatefulWidget {
  final Function(WalkingLocation) onLocationSelected;
  final Function(int) onRadiusChanged;

  const WalkingMapTab(
      {super.key,
      required this.onLocationSelected,
      required this.onRadiusChanged});

  @override
  State<WalkingMapTab> createState() => _WalkingMapTabState();
}

class _WalkingMapTabState extends State<WalkingMapTab> {
  final Completer<GoogleMapController> _mapcontroller =
      Completer<GoogleMapController>();
  CameraPosition initialPosition =
      CameraPosition(target: LatLng(30.044420, 31.235712), zoom: 14);
  LatLng? selectedLocation;
  double radius = 1000.0; // Default radius

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenMap(
                  initialPosition: selectedLocation != null
                      ? CameraPosition(target: selectedLocation!, zoom: 14)
                      : initialPosition,
                  radius: radius,
                ),
              ),
            );

            if (result != null && result is LatLng) {
              setState(() {
                selectedLocation = result;
                widget.onLocationSelected(
                    WalkingLocation(x: result.latitude, y: result.longitude));
              });
            }
          },
          child: Container(
            width: 150.w,
            height: 70.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: kPrimaryGreen),
            child: Center(
              child: Text(
                "Set Location",
                style: Styles.styles14w600.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        if (selectedLocation != null)
          Material(
            elevation: 3.0.sp,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 200.h,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    width: 300.w,
                    child: GoogleMap(
                      markers: {
                        Marker(
                          markerId: MarkerId("selected"),
                          position: selectedLocation!,
                        ),
                      },
                      circles: {
                        Circle(
                          circleId: CircleId("1"),
                          center: selectedLocation!,
                          radius: radius,
                          fillColor: Colors.transparent,
                          strokeColor: kPrimaryGreen,
                          strokeWidth: 3,
                        ),
                      },
                      mapType: MapType.normal,
                      initialCameraPosition:
                          CameraPosition(target: selectedLocation!, zoom: 14),
                      onMapCreated: (GoogleMapController controller) {
                        _mapcontroller.complete(controller);
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Radius (meters)',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  radius = double.tryParse(value) ?? 1000.0;
                                  widget.onRadiusChanged(radius.toInt());
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 90.w,
                          height: 45.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: kPrimaryGreen),
                          child: Center(
                            child: Text("Set Radius",
                                style: Styles.styles14w600
                                    .copyWith(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class FullScreenMap extends StatefulWidget {
  final CameraPosition initialPosition;
  final double radius;

  const FullScreenMap(
      {Key? key, required this.initialPosition, required this.radius})
      : super(key: key);

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  final Completer<GoogleMapController> _mapcontroller =
      Completer<GoogleMapController>();
  List<Marker> markers = [];
  Circle? circle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (markers.isNotEmpty) {
              Navigator.pop(context, markers.first.position);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: GoogleMap(
        onTap: (LatLng latlng) {
          markers.clear();
          markers.add(Marker(
            markerId: MarkerId("selected"),
            position: latlng,
          ));

          // Create a circle around the tapped location
          circle = Circle(
            circleId: CircleId("1"),
            center: latlng,
            radius: widget.radius,
            fillColor: Colors.transparent,
            strokeColor: kPrimaryGreen,
            strokeWidth: 3,
          );

          setState(() {});
        },
        markers: markers.toSet(),
        circles: circle != null ? {circle!} : {},
        mapType: MapType.normal,
        initialCameraPosition: widget.initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapcontroller.complete(controller);
        },
      ),
    );
  }
}
