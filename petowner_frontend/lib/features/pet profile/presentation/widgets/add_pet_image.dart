import 'dart:io';

import 'package:flutter/material.dart';

class AddPetPhoto extends StatefulWidget {
   

  const AddPetPhoto({Key? key,}) : super(key: key); 

  @override
  State<AddPetPhoto> createState() => _AddPetPhotoState();
}

class _AddPetPhotoState extends State<AddPetPhoto> {
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
                  radius: 70,
                  foregroundImage: image != null ? FileImage(image!) : null,
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
            onTap: () async {
            
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 180.0),
              height: 30,
    
              decoration: ShapeDecoration(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                gradient: const LinearGradient(
                  end: Alignment.centerLeft,
                  begin: Alignment.centerRight,
                  colors: [
                    Colors.blue,
                    Colors.green,
                  ],
                ),
              ),
              child: const Icon(Icons.photo),
            ),
          ),
        )
      ],
    );
  }
}