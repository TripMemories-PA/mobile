import 'package:flutter/material.dart';

import '../constants/my_colors.dart';
import 'custom_card.dart';

class ProfileBanner extends StatelessWidget {
  const ProfileBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(50.0),
              ),
              child: Image.asset('assets/images/profileSample.png'),
            ),
          ),
          const Column(
            children: [
              SizedBox(height: 30, width: 25),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Jane Doe',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@jane_doe',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  CustomCard(
                    width: 50,
                    height: 25,
                    backgroundColor: Colors.red,
                    content: Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 15,
                    ),
                    borderColor: Colors.transparent,
                  ),
                  SizedBox(width: 10),
                  CustomCard(
                    width: 100,
                    height: 25,
                    content: Text(
                      'Editer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    borderColor: Colors.transparent,
                    backgroundColor: MyColors.purple,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
