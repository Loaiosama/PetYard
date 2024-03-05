import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/constants/constants.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class ALternativeSignupOptionColumn extends StatelessWidget {
  const ALternativeSignupOptionColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: const Divider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Text(
                'Or',
                style: Styles.styles16,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: const Divider(),
            ),
          ],
        ),
        Center(
          child: Column(
            children: [
              Text(
                'Sign up with',
                style: Styles.styles16,
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.black.withOpacity(0.3), width: 1),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        AssetImage('${Constants.assetsImage}/google_logo.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
