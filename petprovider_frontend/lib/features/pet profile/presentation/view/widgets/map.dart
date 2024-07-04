import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';

class MapPage extends StatefulWidget {
  final Position currentPosition;
  final double ownerLatitude;
  final double ownerLongitude;

  const MapPage({
    Key? key,
    required this.currentPosition,
    required this.ownerLatitude,
    required this.ownerLongitude,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  BitmapDescriptor? customIcon;
  List<Polyline> myPolyline = [];
  Map<PolylineId, Polyline> polyLines = {};

  Future<void> _createCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/images/custom_marker.png', // Replace with your custom marker path
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getPolyLinePoints().then((coordinates) {
      generatePolyLineFromPoints(coordinates);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(30.055137672497928, 31.221092306077484),
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(30.055137672497928, 31.221092306077484),
            infoWindow: InfoWindow(
              title: 'Your Location',
            ),
          ),
          Marker(
            markerId: MarkerId('ownerLocation'),
            position: LatLng(widget.ownerLatitude, widget.ownerLongitude),
            infoWindow: InfoWindow(title: 'Owner\'s Location'),
          ),
        },
        polylines: Set<Polyline>.of(polyLines.values),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }

  Future<List<LatLng>> getPolyLinePoints() async {
    List<LatLng> polyLineCoordinates = [];
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
        googleApiKey: "AIzaSyDZmadm1r3H2xmhROSukCcL60Xc9toBuD4",
        request: PolylineRequest(
            origin: PointLatLng(30.055137672497928, 31.221092306077484),
            destination:
                PointLatLng(widget.ownerLatitude, widget.ownerLongitude),
            mode: TravelMode.driving));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polyLineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: kPrimaryGreen,
        points: polylineCoordinates,
        width: 5);
    setState(() {
      polyLines[id] = polyline;
    });
  }
}
