
import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';

import 'see_all.dart';

class MainServiceWidget extends StatelessWidget {
  const MainServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SeeAllRow(
          title: 'Discover Services',
          onPressed: () {},
        ),
        heightSizedBox(10),
        Container(
          width: double.infinity,
          height: 100,
          color: Colors.grey,
        ),
      ],
    );
  }
}
