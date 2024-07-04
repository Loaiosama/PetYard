import 'package:flutter/material.dart';

import 'description_text_and_buttons.dart';
import 'image_text_fading.dart';

class OnBoardingScreenBody extends StatelessWidget {
  const OnBoardingScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          //svg logo should be here
          BackGroundImageAndTextWithFading(),
          DescriptionTextAndButtonsColumn(),
        ],
      ),
    );
  }
}
