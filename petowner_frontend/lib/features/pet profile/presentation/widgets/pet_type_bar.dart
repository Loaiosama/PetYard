import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
// import 'package:go_router/go_router.dart';

class PetTypeBar extends StatelessWidget {
  const PetTypeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.grey),
          ),
          Column(
            children: [
              Text(
                'Add Pet Profile',
                style: Styles.styles16w600,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'Type',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          const Column(
            children: [
              Text(
                'Steps',
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text('1'),
                  Text(
                    '/5',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
