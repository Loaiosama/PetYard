import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
// import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/type_tile.dart';

class ChooseType extends StatelessWidget {
  const ChooseType({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PetModel petModel = PetModel();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/images/yellow_dog2.jpg",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.60,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(243, 245, 240, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 12.h,
                    ),
                    Center(
                      child: Text(
                        "Choose your pet type ",
                        style: Styles.styles22BoldBlack.copyWith(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        petModel.type = "Dog";
                        context.pushNamed(Routes.kPetBreed, extra: petModel);
                      },
                      child: SizedBox(
                        width: 220.w,
                        height: 220.h,
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1B85F3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 220.w,
                                height: 110.h,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        "Dog",
                                        style: Styles.styles12NormalHalfBlack
                                            .copyWith(
                                                fontSize: 22,
                                                color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 5.sp,
                                left: 5.sp,
                                right: 70.sp,
                                child: Image.asset(
                                    width: 170.w,
                                    height: 170.h,
                                    "assets/images/onBoarding_dog_copy.png"))
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        petModel.type = "Cat";
                        context.pushNamed(Routes.kPetBreed, extra: petModel);
                      },
                      child: SizedBox(
                        width: 220.w,
                        height: 220.h,
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kBlue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 220.w,
                                height: 110.h,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        "Cat",
                                        style: Styles.styles12NormalHalfBlack
                                            .copyWith(
                                                fontSize: 22,
                                                color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: -5.sp,
                                left: 0.sp,
                                right: 75.sp,
                                child: Image.asset(
                                    width: 175.w,
                                    height: 175.h,
                                    "assets/images/open_mouth_cat.png"))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.85);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * 0.85,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// import 'package:flutter/material.dart';

// class ChooseType extends StatelessWidget {
//   const ChooseType({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choose Pet Type'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text(
//               'Select the type of pet you want to add:',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             PetTypeButton(
//               label: 'Cat',
//               image: 'assets/cat.png', // Ensure you have this asset
//               onTap: () {
//                 Navigator.pop(context, 'Cat');
//               },
//             ),
//             const SizedBox(height: 20),
//             PetTypeButton(
//               label: 'Dog',
//               image: 'assets/dog.png', // Ensure you have this asset
//               onTap: () {
//                 Navigator.pop(context, 'Dog');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PetTypeButton extends StatelessWidget {
//   final String label;
//   final String image;
//   final VoidCallback onTap;

//   const PetTypeButton({
//     Key? key,
//     required this.label,
//     required this.image,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 150,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Image.asset(
//                 image,
//                 width: 100,
//                 height: 100,
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: Text(
//                   label,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
