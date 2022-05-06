import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/modules/home/controllers/home_controller.dart';

class NetworkController extends GetxController {
  var connectionStatus = 0.obs;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectionSubscription;

  HomeController homeController = Get.put(HomeController());
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initConnectivity();
    connectionSubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  initConnectivity() async {
    ConnectivityResult? result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return updateConnectionStatus(result!);
  }

  updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionStatus.value = 2;
        homeController.checkPermission();
        Get.snackbar('Network Connection ', 'Connected to Wifi');
        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = 1;
        Get.snackbar('Network Connection ', 'Connected to Mobile Internet');
        homeController.checkPermission();
        break;
      case ConnectivityResult.ethernet:
        connectionStatus.value = 3;
        Get.snackbar('Network Connection ', 'Connected to Ethernet');
        homeController.checkPermission();
        break;
      case ConnectivityResult.none:
        connectionStatus.value = 0;
        Get.snackbar('Connection Lost', 'No Connected to Internet');
        break;
      default:
        Get.snackbar('Network Error', 'failed to get network connection.');
        break;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    connectionSubscription.cancel();
  }
}
