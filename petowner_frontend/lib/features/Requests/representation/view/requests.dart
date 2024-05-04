import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/Requests/representation/view/widgets/service_req_tile.dart';

class Requests extends StatelessWidget {
   Requests({super.key});

  @override
  List services = [

      ServiceReqTile(title: 'Walking',
      subTitle: 'get a carer that will give your pet a nice walk insde the area that you want ',
      imagePath: 'assets/images/pet_walking.png',
       onTap: (){},
      ),

      ServiceReqTile(title: 'Boarding',
      subTitle: 'get a carer that give your pet a nice treatment inside his home',
      imagePath: 'assets/images/pet_boarding.png',
       onTap: () {},
       ),

      ServiceReqTile(title: 'Sitting',
      subTitle: 'get a carer that will give your pet a nice treatment inside your home',
      imagePath: 'assets/images/pet_setting.png', 
      onTap: () {},
      ),

      ServiceReqTile(title: 'Grooming',
      subTitle: 'Make your pet extra happy with alot of grooming services here',
      imagePath: 'assets/images/cat-bath_1810158.png',
       onTap: () {},
       ),

  ];
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Choose Service" , 
                 style: Styles.styles22BoldGreen.copyWith(fontSize: 18),
                ),
            ), 
        
              SizedBox(
                height: 25.h,
              ) , 
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context,index) =>services[index],
                  itemCount: services.length,
                  ),
              ),
        
        
              
        
          ],
          
        ),
      ),
    );
  }
}

