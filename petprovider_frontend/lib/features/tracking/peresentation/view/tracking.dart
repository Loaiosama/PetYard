// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:petprovider_frontend/core/utils/theming/colors.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class TrackingWalking extends StatefulWidget {
//   final double lat;
//   final double long;
//   final double radius;
//   const TrackingWalking(
//       {super.key, required this.lat, required this.long, required this.radius});

//   @override
//   State<TrackingWalking> createState() => _TrackingWalkingState();
// }

// class _TrackingWalkingState extends State<TrackingWalking> {
//   Position? position;
//   StreamSubscription<Position>? positionStream;
//   late WebSocketChannel channel;
//   late LatLng latLng;

//   Set<Marker> markers = {}; // Mutable set of markers

//   @override
//   void initState() {
//     super.initState();
//     latLng = LatLng(widget.lat, widget.long);
//     connectWebSocket();
//     getCurrentLocation();
//   }

//   void connectWebSocket() {
//     try {
//       channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.191:8081'));
//       channel.stream.listen((message) {
//         print('Received from server: $message');
//       }, onError: (error) {
//         print('WebSocket error: $error');
//       });
//     } catch (e) {
//       print('Error connecting to WebSocket: $e');
//     }
//   }

//   Future<void> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print("Enable location in your device");
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print("Location permission denied");
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       print("Location permissions are permanently denied");
//       return;
//     }

//     if (permission == LocationPermission.whileInUse ||
//         permission == LocationPermission.always) {
//       positionStream = Geolocator.getPositionStream().listen(
//         (Position? newPosition) {
//           if (newPosition != null) {
//             setState(() {
//               position = newPosition;
//               latLng = LatLng(position!.latitude, position!.longitude);
//               updateMarker(); // Update marker position
//               sendLocation(position!);
//             });
//           }
//         },
//         onError: (error) {
//           print('Error getting position: $error');
//         },
//       );
//     }
//   }

//   void updateMarker() {
//     markers.clear(); // Clear previous markers
//     markers.add(
//       Marker(
//         markerId: MarkerId("current_position"),
//         position: latLng,
//         infoWindow: InfoWindow(
//           title: 'Your Location',
//         ),
//         icon: BitmapDescriptor.defaultMarker, // Customize icon if needed
//       ),
//     );
//   }

//   void sendLocation(Position position) {
//     final locationData = {
//       'latitude': position.latitude,
//       'longitude': position.longitude,
//     };
//     final encodedData = jsonEncode(locationData);
//     try {
//       channel.sink.add(encodedData);
//     } catch (e) {
//       print('Error sending data: $e');
//     }
//   }

//   @override
//   void dispose() {
//     positionStream?.cancel();
//     channel.sink.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Tracking Walking"),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: LatLng(
//               widget.lat, widget.long), // Use the initial values directly
//           zoom: 13,
//         ),
//         markers: markers,
//         circles: {
//           Circle(
//             circleId: CircleId("radius"),
//             center: LatLng(widget.lat, widget.long),
//             radius: widget.radius,
//             strokeWidth: 3,
//             strokeColor: kPrimaryGreen,
//             fillColor: Colors.transparent,
//           ),
//         },
//         onMapCreated: (GoogleMapController controller) {},
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TrackingWalking extends StatefulWidget {
  final double lat;
  final double long;
  final int radius;
  const TrackingWalking(
      {super.key, required this.lat, required this.long, required this.radius});

  @override
  State<TrackingWalking> createState() => _TrackingWalkingState();
}

class _TrackingWalkingState extends State<TrackingWalking> {
  Position? position;
  StreamSubscription<Position>? positionStream;
  late WebSocketChannel channel;
  late LatLng latLng;

  Set<Marker> markers = {}; // Mutable set of markers

  @override
  void initState() {
    super.initState();
    latLng = LatLng(widget.lat, widget.long);
    connectWebSocket();
    getCurrentLocation();
  }

  void connectWebSocket() {
    try {
      channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.191:8081'));
      channel.stream.listen((message) {
        print('Received from server: $message');
      }, onError: (error) {
        print('WebSocket error: $error');
      });
    } catch (e) {
      print('Error connecting to WebSocket: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Enable location in your device");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied");
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      positionStream = Geolocator.getPositionStream().listen(
        (Position? newPosition) {
          if (newPosition != null) {
            setState(() {
              position = newPosition;
              latLng = LatLng(position!.latitude, position!.longitude);
              updateMarker(); // Update marker position
              sendLocation(position!);
            });
          }
        },
        onError: (error) {
          print('Error getting position: $error');
        },
      );
    }
  }

  void updateMarker() {
    markers.clear(); // Clear previous markers
    markers.add(
      Marker(
        markerId: MarkerId("current_position"),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Your Location',
        ),
        icon: BitmapDescriptor.defaultMarker, // Customize icon if needed
      ),
    );
  }

  void sendLocation(Position position) {
    final locationData = {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
    final encodedData = jsonEncode(locationData);
    try {
      channel.sink.add(encodedData);
    } catch (e) {
      print('Error sending data: $e');
    }
  }

  @override
  void dispose() {
    positionStream?.cancel();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracking Walking"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
              widget.lat, widget.long), // Use the initial values directly
          zoom: 13,
        ),
        markers: markers,
        circles: {
          Circle(
            circleId: CircleId("radius"),
            center: LatLng(widget.lat, widget.long),
            radius: widget.radius.toDouble(),
            strokeWidth: 3,
            strokeColor: kPrimaryGreen,
            fillColor: Colors.transparent,
          ),
        },
        onMapCreated: (GoogleMapController controller) {},
      ),
    );
  }
}
