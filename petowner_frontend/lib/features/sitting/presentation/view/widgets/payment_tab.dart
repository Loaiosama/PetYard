import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class PaymentTabSitting extends StatefulWidget {
  final Function(double) onPriceSelected;
  const PaymentTabSitting({Key? key, required this.onPriceSelected})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PaymentTabSittingState createState() => _PaymentTabSittingState();
}

class _PaymentTabSittingState extends State<PaymentTabSitting> {
  double price = 0.0;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = price.toStringAsFixed(2);
  }

  void incrementPrice() {
    setState(() {
      price++;
      widget.onPriceSelected(price);
      _controller.text = price.toStringAsFixed(2);
    });
  }

  void decrementPrice() {
    setState(() {
      if (price > 0) {
        price--;
        widget.onPriceSelected(price);
        _controller.text = price.toStringAsFixed(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25.h,
        ),
        Text(
          "Enter Price:",
          style: Styles.styles14w600,
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: Container(
                width: 200.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: kPrimaryGreen,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextFormField(
                    controller: _controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: 'Enter the price',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // Handle onChanged if necessary
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w), // Spacer between text field and buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 35.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kPrimaryGreen,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      incrementPrice();
                    },
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  width: 35.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kPrimaryGreen,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      decrementPrice();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 30.h),
        Text(
          "Payment Options",
          style: Styles.styles14w600,
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Radio(
              value: 'Cash',
              groupValue: 'Cash',
              onChanged: (value) {},
            ),
            Text(
              "Cash",
              style: Styles.styles12w600,
            ),
          ],
        ),
        SizedBox(
          height: 250.h,
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when done
    super.dispose();
  }
}
