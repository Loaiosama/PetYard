import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/constants/constants.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
// import 'package:petowner_frontend/features/pet%20profile/presentation/pet_breed.dart';
// import 'package:petowner_frontend/features/registration/signin/presentation/view/signin.dart';
// import 'package:petowner_frontend/core/utils/theming/colors.dart';

class RPetImageButton extends StatelessWidget {
  const RPetImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          GoRouter.of(context).push(Routes.kPetBreed);
        },
        //changed the color here to our green with opacity still the same in the dog one
        splashColor: kPrimaryGreen.withOpacity(0.3),
        child: Row(children: [
          Ink.image(
            //resized the image to fix the loading part and it worked quite well
            //(better than before)
            image: AssetImage('${Constants.assetsImage}/cat_copy.png'),
            height: 150,
            width: 150,
            fit: BoxFit.fill,
          ),
          SizedBox(
            width: 30.w,
          ),
          const Text(
            'Cat',
          ),
          SizedBox(
            width: 30.w,
          )
        ]),
      ),
    );
  }
}

class LPetImageButton extends StatelessWidget {
  const LPetImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {},
        splashColor: kPrimaryGreen.withOpacity(0.3),
        child: Row(children: [
          SizedBox(
            width: 30.w,
          ),
          const Text(
            'Dog',
          ),
          SizedBox(
            width: 30.w,
          ),
          Ink.image(
            image: AssetImage('${Constants.assetsImage}/dog_copy.png'),
            height: 150,
            width: 150,
            fit: BoxFit.fill,
          ),
        ]),
      ),
    );
  }
}
