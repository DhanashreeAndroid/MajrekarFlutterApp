import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color orange = const Color(0xffFCAF17);
Color white = Colors.white;
Color puprle = const Color(0xff16182C);

snakbar(String title, String subTitle) {
  Get.snackbar(title, subTitle,
      backgroundColor: orange,
      snackPosition: SnackPosition.BOTTOM,
      colorText: white).show();
}

errorSnakbar(String title, String subTitle) {
  Get.snackbar(title, subTitle,
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      colorText: white).show();
}