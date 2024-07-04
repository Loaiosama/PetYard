import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/Pet.dart';
import 'package:petprovider_frontend/features/pet%20profile/data/model/owner.dart';
import 'package:petprovider_frontend/features/pet%20profile/presentation/view/widgets/map.dart';
import 'package:stroke_text/stroke_text.dart';

class PetOwnerProfile extends StatefulWidget {
  final Owner owner;
  final Pet pet;

  const PetOwnerProfile({super.key, required this.owner, required this.pet});

  @override
  State<PetOwnerProfile> createState() => _PetOwnerProfileState();
}

class _PetOwnerProfileState extends State<PetOwnerProfile> {
  late Future<String> locationFuture;
  double distance = 0;
  Position? position;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    if (widget.owner.location?.x != null && widget.owner.location?.y != null) {
      locationFuture =
          _codingLocation(widget.owner.location!.x!, widget.owner.location!.y!);
    }
  }

  Future<String> _codingLocation(double x, double y) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(x, y);
    String loc =
        "${placemarks[0].subAdministrativeArea} ${placemarks[0].locality} ${placemarks[0].street}";
    return loc;
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
      position = await Geolocator.getCurrentPosition();
      setState(() {
        if (widget.owner.location != null &&
            widget.owner.location!.x != null &&
            widget.owner.location!.y != null) {
          distance = Geolocator.distanceBetween(
                position!.latitude,
                position!.longitude,
                widget.owner.location!.x!,
                widget.owner.location!.y!,
              ) /
              1000;
          print('Distance: $distance km');
        } else {
          print('Owner location is not available');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.60,
              width: double.infinity,
              child: Image.asset(
                'assets/images/profile_dog2.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 6.0.w, right: 6.0.w, top: 40.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 130.h),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Material(
                        elevation: 2.0.sp,
                        color: Colors.white,
                        shadowColor: kPrimaryGreen,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.3),
                            strokeAlign: 3,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 60.0.h, right: 20.0.w, left: 40.0.w),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "${widget.pet.name} Owner",
                                          style: Styles.styles16w600,
                                        ),
                                        Text(
                                          "${widget.owner.firstName} ${widget.owner.lastName}",
                                          style: Styles.styles12NormalHalfBlack
                                              .copyWith(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Center(
                                      child: Container(
                                        height: 40.h,
                                        width: 140.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0.r),
                                          color: kPrimaryGreen,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (position != null &&
                                                widget.owner.location != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MapPage(
                                                    currentPosition: position!,
                                                    ownerLatitude: widget
                                                        .owner.location!.x!,
                                                    ownerLongitude: widget
                                                        .owner.location!.y!,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              print(
                                                  "Position or owner location is null");
                                            }
                                          },
                                          child: Center(
                                              child: Text(
                                            'Show Distance',
                                            style: Styles.styles14NormalBlack
                                                .copyWith(color: Colors.white),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Personal information",
                                  style: Styles.styles16w600,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                InfoContainer(
                                  color: Color.fromRGBO(184, 81, 98, 1),
                                  title: "Phone",
                                  value: widget.owner.phone,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                InfoContainer(
                                  color: const Color.fromRGBO(85, 164, 239, 1),
                                  title: "Mail",
                                  value: widget.owner.email,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                InfoContainer(
                                  color: const Color.fromRGBO(240, 188, 68, 1),
                                  title: "Date Of Birth",
                                  value: widget.owner.dateOfBirth.toString(),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                FutureBuilder<String>(
                                  future: locationFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        "Error loading location",
                                        style: Styles.styles16BoldBlack
                                            .copyWith(color: Colors.black),
                                      );
                                    } else if (snapshot.hasData) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          Text(
                                            "Location",
                                            style: Styles.styles16w600,
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.locationPin,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(
                                                snapshot.data!,
                                                style: Styles
                                                    .styles12NormalHalfBlack,
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),
                                SizedBox(height: 15.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 170.h,
              left: 36.w,
              child: CircleAvatar(
                  radius: 45.sp,
                  backgroundImage: AssetImage("assets/images/Suiiiiiiiii.jpg")),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoContainer extends StatelessWidget {
  final String title;
  final Color color;
  final String? value;
  final Future<String>? locationFuture;

  const InfoContainer({
    super.key,
    required this.color,
    required this.title,
    this.value,
    this.locationFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0.r),
        color: color,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 35.0.sp,
            right: 20.sp,
            child: Transform.rotate(
              angle: -0.4,
              child: Icon(
                FontAwesomeIcons.paw,
                color: Colors.white.withOpacity(0.3),
                size: 56.0.sp,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: Styles.styles16w600.copyWith(
                  color: Colors.white,
                ),
              ),
              if (locationFuture != null)
                FutureBuilder<String>(
                  future: locationFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        "Error loading location",
                        style: Styles.styles16BoldBlack
                            .copyWith(color: Colors.white),
                      );
                    } else if (snapshot.hasData) {
                      return StrokeText(
                        text: snapshot.data!,
                        textStyle: Styles.styles14NormalBlack
                            .copyWith(color: Colors.white),
                        strokeWidth: 0.5,
                      );
                    } else {
                      return Text(
                        "No Location",
                        style: Styles.styles16BoldBlack
                            .copyWith(color: Colors.white),
                      );
                    }
                  },
                )
              else if (value != null)
                StrokeText(
                  text: value!,
                  textStyle:
                      Styles.styles16BoldBlack.copyWith(color: Colors.white),
                  strokeWidth: 0.5,
                )
              else
                Text(
                  "No data",
                  style: Styles.styles16BoldBlack.copyWith(color: Colors.white),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
