import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';

List<IconData> icons = [
  FontAwesomeIcons.addressCard,
  FontAwesomeIcons.clockRotateLeft,
  FontAwesomeIcons.locationDot,
];

List labels = ['Personal Information', 'History', 'Location'];

List cardColors = [
  const Color.fromRGBO(234, 242, 255, 1),
  const Color.fromRGBO(233, 250, 239, 1),
  const Color.fromRGBO(255, 238, 239, 1),
];

List iconColors = [
  const Color.fromRGBO(36, 124, 255, 1),
  const Color.fromRGBO(34, 197, 94, 1),
  const Color.fromRGBO(255, 76, 94, 1),
];

List routes = [
  Routes.kPersonalInformation,
  Routes.kPersonalInformation,
  Routes.kProfileLocation,
];
