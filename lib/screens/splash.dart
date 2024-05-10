import 'package:artvista/customizations/app_style.dart';
import 'package:artvista/customizations/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.popAndPushNamed(context, "/App_Layout");
    });

    SizeConfig().init(context);
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/splash (1).png',
              ),
              colorFilter: ColorFilter.mode(
                Color.fromARGB(255, 135, 1, 135),
                BlendMode.modulate,
              ),
              fit: BoxFit.cover),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 135, 1, 135),
              Color.fromARGB(255, 135, 1, 135),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(
                  'assets/images/artvista logo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 30,
            ),
            // const SpinKitSpinningLines(
            //   duration: Duration(milliseconds: 5000),
            //   color: Color(0xfffE8C61E),
            //   itemCount: 7,
            // ),
            Text('from',
                style: kEncodeSansRegular.copyWith(
                    color: kLightGrey,
                    fontSize: SizeConfig.blockSizeHorizontal! * 1.5)),
            Text('AUDREY ART',
                style: kEncodeSansBold.copyWith(
                    color: kLightGrey,
                    fontSize: SizeConfig.blockSizeHorizontal! * 2.5)),
          ],
        ));
  }
}
