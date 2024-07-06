import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
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
  late WebSocketChannel channel;
  late LatLng latLng;
  Set<Marker> markers = {}; // Mutable set of markers

  @override
  void initState() {
    super.initState();
    latLng = LatLng(widget.lat, widget.long);
    connectWebSocket();
  }

  void connectWebSocket() {
    try {
      channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.191:8082'));
      channel.stream.listen((message) {
        print('Received message: $message'); // Log the received message
        try {
          final data = jsonDecode(message);
          final double latitude = data['latitude'];
          final double longitude = data['longitude'];
          print(latitude);
          print("==========");
          print(longitude);
          setState(() {
            latLng = LatLng(latitude, longitude);
            updateMarker();
          });
        } catch (e) {
          print('Error decoding JSON: $e');
        }
      }, onError: (error) {
        print('WebSocket error: $error');
      });
    } catch (e) {
      print('Error connecting to WebSocket: $e');
    }
  }

  void updateMarker() {
    markers.clear(); // Clear previous markers
    markers.add(
      Marker(
        markerId: MarkerId("current_position"),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Current Location',
        ),
        icon: BitmapDescriptor.defaultMarker, // Customize icon if needed
      ),
    );
  }

  @override
  void dispose() {
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
          target: latLng, // Use the initial values directly
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
