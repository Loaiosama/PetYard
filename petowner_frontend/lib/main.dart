import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pet_yard.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black38, // status bar color
  ));
  runApp(const PetYardApp());
}
