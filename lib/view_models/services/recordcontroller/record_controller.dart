import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ButtonController extends GetxController {
  var isLoading = false.obs;

  void startLoading() {
    isLoading.value = true;
  }

  void stopLoading() {
    isLoading.value = false;
  }
}
