import 'package:flutter/material.dart';

class PetInformationScreen extends StatelessWidget {
  const PetInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const PetInfromationScreenBody(),
    );
  }
}

class PetInfromationScreenBody extends StatelessWidget {
  const PetInfromationScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}
