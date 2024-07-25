
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// void showMessage({message, context}) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     content: Text(message),
//     duration: const Duration(seconds: 3),
//     behavior: SnackBarBehavior.floating,
//     backgroundColor: Colors.purple,
//   ));
// }
const success = Color(0xFF02C20F);
const white = Color(0xFFFFFFFF);
// enum SnackPosition {TOP}


showErrorSnackbar({required String message, String? title, Color? color}) {
  final overlayContext = Get.overlayContext;
  if (overlayContext != null) {
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      title: title,
      message: message,
      isDismissible: false,
      backgroundColor: color ?? Colors.red,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      borderRadius: 16.0,
      mainButton: GestureDetector(
        onTap: () => Get.back(),
        child: const Icon(
          CupertinoIcons.clear_circled,
          color: Colors.white,
        ),
      ),
    );
  } else {
    // Logger.log("overlay context is null");
  }
}

showSuccessSnackbar(
    {required String message, String? title, Color? color, Color? textColor,
    SnackPosition? snackPosition}) {
  final overlayContext = Get.overlayContext;
  if (overlayContext != null) {
    Get.rawSnackbar(
      snackPosition: snackPosition ?? SnackPosition.TOP,
      title: title,
      message: message,
      isDismissible: false,
      backgroundColor: color ?? success,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      borderRadius: 16.0,
      mainButton: GestureDetector(
        onTap: (){},
        child: const Icon(
          CupertinoIcons.clear_circled,
          color: white,
        ),
      ),
    );
  } else {
   // Logger('Utils').log("overlay context is null");
  }
}