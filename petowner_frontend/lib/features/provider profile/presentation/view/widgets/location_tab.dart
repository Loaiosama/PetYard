import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class LocationTabColumn extends StatefulWidget {
  const LocationTabColumn({super.key, required this.lat, required this.long});
  final double lat;
  final double long;

  @override
  State<LocationTabColumn> createState() => _LocationTabColumnState();
}

class _LocationTabColumnState extends State<LocationTabColumn> {
  String address = 'Loading...';
  late GoogleMapController mapController;
  late CameraPosition initialCameraPosition;

  @override
  void initState() {
    super.initState();
    initialCameraPosition = CameraPosition(
      target: LatLng(widget.lat, widget.long),
      zoom: 14,
    );
    // _getAdd();
  }

  // Future<void> _getAdd() async {
  //   try {
  //     print('object');
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(widget.lat, widget.long);
  //     print('object1');
  //     Placemark providerAdd = placemarks[0];
  //     print('object2');
  //     setState(() {
  //       address = "${providerAdd.locality}, ${providerAdd.street}";
  //       print('object3');
  //     });
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       address = 'Unknown location';
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSizedBox(12),
        // Row(
        //   children: [
        //     Icon(
        //       FontAwesomeIcons.locationDot,
        //       color: const Color.fromRGBO(255, 76, 94, 1),
        //       size: 16.sp,
        //     ),
        //     widthSizedBox(8),
        //     FutureBuilder(
        //       future: _getAdd(),
        //       builder: (context, snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return Text(
        //             'Loading...',
        //             style: Styles.styles12NormalHalfBlack,
        //           );
        //         } else if (snapshot.hasError) {
        //           return Text(
        //             'Error loading location',
        //             style: Styles.styles12NormalHalfBlack,
        //           );
        //         } else {
        //           return Text(
        //             address,
        //             style: Styles.styles12NormalHalfBlack,
        //           );
        //         }
        //       },
        //     ),
        //   ],
        // ),
        heightSizedBox(18),
        Text(
          'Location Map',
          style: Styles.styles16w600,
        ),
        heightSizedBox(10),

        widget.lat != 0.0 && widget.long != 0.0
            ? Container(
                height: 360.h,
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                  markers: {
                    Marker(
                      markerId: MarkerId('selectedLocation'),
                      position: LatLng(widget.lat, widget.long),
                    ),
                  },
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                ),
              )
            : const Center(
                child: Text('No Location'),
              ),
      ],
    );
  }
}
