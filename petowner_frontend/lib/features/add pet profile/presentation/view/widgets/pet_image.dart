import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PetImage extends StatefulWidget {
  const PetImage({
    super.key,
  });

  @override
  State<PetImage> createState() => _AddPetPhotoState();
}

class _AddPetPhotoState extends State<PetImage> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            gradient: LinearGradient(
              end: Alignment.centerLeft,
              begin: Alignment.centerRight,
              colors: [
                Colors.blue,
                Colors.green,
              ],
            ),
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
                  radius: 56.r,
                  foregroundImage: image != null ? FileImage(image!) : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
