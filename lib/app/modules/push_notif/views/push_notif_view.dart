import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/push_notif_controller.dart';

class PushNotifView extends StatelessWidget {
  final controller = Get.put(PushNotifController());
  PushNotifView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PushNotifView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PushNotifView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
