import 'package:get/get.dart';
import 'package:weather_app/NetworkController.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.put(NetworkController());
  }
}
