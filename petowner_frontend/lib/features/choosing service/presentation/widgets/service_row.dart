// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:petowner_frontend/core/utils/theming/colors.dart';
// import 'package:petowner_frontend/core/utils/theming/styles.dart';
// import 'package:petowner_frontend/features/choosing%20service/presentation/widgets/service_row_item.dart';
// class ServiceRow extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: Center(
//         child: Container(
//           width: 250.w,
//           height: 150.h,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5), 
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: Offset(0, 3),
//               )
//             ],
//           ),
//           child: const Padding(
//             padding: EdgeInsets.all(20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ServiceRowItem(icon: Icons.request_page, text: 'Requests'),
//                 ServiceRowItem(icon: Icons.design_services, text: 'Service'),
//                 ServiceRowItem(icon: Icons.calendar_month, text: 'Date'),
//                 ServiceRowItem(icon: Icons.question_mark_rounded, text: 'Get Help'),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }