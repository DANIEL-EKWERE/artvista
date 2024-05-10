import 'package:artvista/customizations/app_style.dart';
import 'package:artvista/customizations/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.black,
        ),
        iconTheme: const IconThemeData(color: kWhite),
        flexibleSpace:
            Container(decoration: const BoxDecoration(color: Colors.black)),
        title: Text(
          'Favourites',
          style: kEncodeSansBold.copyWith(
              color: kWhite, fontSize: SizeConfig.blockSizeHorizontal! * 2.5),
        ),
        centerTitle: true,
      ),
    );
  }
}
