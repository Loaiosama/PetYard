import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';

class AddPetPhoto extends StatefulWidget {
  const AddPetPhoto({
    super.key,
  });

  @override
  State<AddPetPhoto> createState() => _AddPetPhotoState();
}

class _AddPetPhotoState extends State<AddPetPhoto> {
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  void pickImage(ImageSource source) async {
    var img = await _picker.pickImage(source: source);
    setState(() {
      image = img;
    });
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  leading: const Icon(Iconsax.camera),
                  title: const Text('Camera'),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  leading: const Icon(Iconsax.gallery),
                  title: const Text('Gallery'),
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            color: kPrimaryGreen,
          ),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: CircleAvatar(
                  radius: 60.r,
                  // backgroundImage: image != null
                  //     ? FileImage(File(image!.path))
                  //     : AssetImage('assetName'),
                  backgroundImage: AssetImage('assets/images/pet_blank.jpg'),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () => _showPicker(context),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 180.0),
              height: 30,
              decoration: ShapeDecoration(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                color: kPrimaryGreen,
              ),
              child: Icon(
                FontAwesomeIcons.penToSquare,
                color: Colors.white,
                size: 14.sp,
              ),
            ),
          ),
        )
      ],
    );
  }
}
