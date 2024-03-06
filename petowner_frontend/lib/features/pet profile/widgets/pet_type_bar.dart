import 'package:flutter/material.dart';

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
                  onPressed: (){},
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.grey
                    ) , 
                  ),
                    const Column(
                    children: [
                       Text('Add Pet Profile'), 
                      SizedBox(
                        height: 5,
                      ),
                       Text(
                        'Type',
                        style: TextStyle(
                          color : Colors.grey , 
                        ) ,
                      ),
                    ],
                  ),
                  const Column(
                    children: [
                      Text(
                        'Steps',
                        
                        ) , 
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text('1'),
                          Text(
                            '/5' ,
                            style: TextStyle(
                              color : Colors.grey , 
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