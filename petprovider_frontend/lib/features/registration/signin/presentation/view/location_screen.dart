import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/petyard_text_button.dart';
import 'package:petprovider_frontend/features/registration/signin/data/repo/sign_in_repo.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _SingInMapState();
}

class _SingInMapState extends State<LocationScreen> {
  late GoogleMapController mapController;

  LatLng? _selectedLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  // void _onContinue() {
  //   if (_selectedLocation != null) {
  //     double latitude = _selectedLocation!.latitude;
  //     double longitude = _selectedLocation!.longitude;
  //     // print(latitude);
  //     // print(longitude);
  //     // GoRouter.of(context).push(Routes.kHomeScreen, extra: 0);

  //     // navigate hna ya hmadyyyyy
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please select a location on the map.')),
  //     );
  //   }
  // }
  final SignInRepo signInRepo = SignInRepo(api: ApiService(dio: Dio()));
  void _onContinue() async {
    if (_selectedLocation != null) {
      double latitude = _selectedLocation!.latitude;
      double longitude = _selectedLocation!.longitude;

      var result = await signInRepo.updateProviderLocation(
        lat: latitude,
        long: longitude,
      );

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to update location: ${failure.errorMessage}')),
          );
        },
        (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          GoRouter.of(context).push(Routes.kHomeScreen, extra: 0);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Selcet Your location",
          style: Styles.styles14NormalBlack,
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: GoogleMap(
            initialCameraPosition: const CameraPosition(
                target: LatLng(30.148854099726652, 31.629562300000003),
                zoom: 12),
            onMapCreated: _onMapCreated,
            onTap: _onTap,
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selectedLocation'),
                      position: _selectedLocation!,
                    ),
                  }
                : {},
          )),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: PetYardTextButton(
                onPressed: _onContinue,
                text: "Continue",
                style: Styles.styles16BoldWhite,
              )),
        ],
      ),
    );
  }
}
