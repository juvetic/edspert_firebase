import 'package:get/get.dart';

import '../controllers/push_notif_controller.dart';

class PushNotifBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PushNotifController>(
      () => PushNotifController(),
    );
  }
}
