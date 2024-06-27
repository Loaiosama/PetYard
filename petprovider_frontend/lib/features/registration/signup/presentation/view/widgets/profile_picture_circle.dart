import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureCircle extends StatefulWidget {
  const ProfilePictureCircle({Key? key, required this.onImageSelected});

  final void Function(XFile?) onImageSelected;

  @override
  State<ProfilePictureCircle> createState() => _ProfilePictureCircleState();
}

class _ProfilePictureCircleState extends State<ProfilePictureCircle> {
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  void pickImage(ImageSource source) async {
    var img = await _picker.pickImage(source: source);
    setState(() {
      image = img;
    });
    widget.onImageSelected(image); // Notify parent widget with selected image
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

  ImageProvider<Object>? _getImageProvider() {
    if (image == null) {
      return AssetImage('assets/images/1.png'); // Placeholder image
    } else {
      return FileImage(File(image!.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.0.w,
      height: 130.0.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: _getImageProvider()!,
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.white,
          width: 4.0.w,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          width: 34.w,
          height: 34.h,
          margin: EdgeInsets.only(top: 40.0.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 4.0.w,
            ),
            shape: BoxShape.circle,
            color: const Color.fromRGBO(248, 248, 248, 1),
          ),
          child: IconButton(
            onPressed: () => _showPicker(context),
            icon: Center(
              child: Icon(
                FontAwesomeIcons.penToSquare,
                size: 13.sp,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
