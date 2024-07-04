import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class PaymentTab extends StatelessWidget {
  const PaymentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Options',
          style: Styles.styles14w600,
        ),
        heightSizedBox(10),
        Row(
          children: [
            Radio(
              value: 'cash',
              groupValue: 'cash',
              onChanged: (value) {},
            ),
            Text(
              'Cash',
              style: Styles.styles12w600,
            ),
          ],
        ),
      ],
    );
  }
}
