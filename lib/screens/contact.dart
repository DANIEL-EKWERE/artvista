import 'package:artvista/customizations/size_config.dart';
import 'package:flutter/material.dart';

import '../customizations/app_style.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
      SizeConfig().init(context);
    double sizeVertical = SizeConfig.blockSizeHorizontal!;
    double sizeHorizontal = SizeConfig.blockSizeVertical!;
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                height: sizeHorizontal * 35,
                decoration: const BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.online_prediction,
                          color: kWhite,
                          size: 30,
                        ),
                        SizedBox(
                          width: sizeVertical * 2.5,
                        ),
                        Text(
                          'Customer Care services.... 8am\n to 10pm',
                          style: kEncodeSansSemiBold.copyWith(
                              color: kWhite,
                              fontSize: SizeConfig.blockSizeHorizontal! * 1.8),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHorizontal * 2.5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: kWhite,
                          size: 30,
                        ),
                        SizedBox(
                          width: sizeHorizontal * 2.5,
                        ),
                        Text(
                          '07013116710',
                          style: kEncodeSansSemiBold.copyWith(
                              color: kWhite,
                              fontSize: SizeConfig.blockSizeHorizontal! * 1.8),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHorizontal * 2.5,
                    ),
                    Row(
                      children: [
                       const  Icon(
                          Icons.location_on,
                          color: kWhite,
                          size: 30,
                        ),
                        SizedBox(
                          width: sizeHorizontal * 2.5,
                        ),
                        Text(
                          'N0. 13 Brooke Str uyo,aks',
                          style: kEncodeSansSemiBold.copyWith(
                              color: kWhite,
                              fontSize: SizeConfig.blockSizeHorizontal! * 1.8),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHorizontal * 2.5,
                    ),
                    Row(
                      children: [
                      const   Icon(
                          Icons.email,
                          color: kWhite,
                          size: 30,
                        ),
                        SizedBox(
                          width: sizeHorizontal * 2.5,
                        ),
                        Text(
                          'databank8@gmail.com',
                          style: kEncodeSansSemiBold.copyWith(
                              color: kWhite,
                              fontSize: SizeConfig.blockSizeHorizontal! * 1.8),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}