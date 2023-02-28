import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/firestore_controller.dart';
import '../widgets/chat_item_widget.dart';
import '../widgets/input_chat.dart';

/// C is a generic class can referred to other class based on assignment
/// In this case other engineer can create new controller but must extends
/// from [DiscussionController]. So, you will not double lifecycle execution.
class FirestoreFetch extends StatelessWidget {
  final controller = Get.put(FirestoreController());
  static const routeName = '/discussion';

  FirestoreFetch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: buildAppBar(context),
      body: buildBody(context),
      bottomNavigationBar: buildBottom(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Diskusi Soal'),
      actions: [
        IconButton(
          onPressed: controller.readData,
          icon: Icon(Icons.refresh),
        ),
        IconButton(
          onPressed: controller.clear,
          icon: Icon(Icons.delete),
        )
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMessages) {
        return buildLoading(context);
      }

      return buildData(context);
    });
  }

  Widget buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  Widget buildData(BuildContext context) {
    return GetBuilder<FirestoreController>(
      builder: (c) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final chat = controller.messages[index];
            return ChatItemWidget(chat: chat);
          },
          itemCount: controller.messages.length,
          reverse: true,
        );
      }
    );
  }

  Widget buildBottom(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Card(
      elevation: 16,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: InputChatWidget(
          controller: controller.msgController,
          onTapAdd: () => onTapAdd(context),
          onTapCamera: () => onTapCamera(context),
          onTapSend: () => controller.sendChat(),
        ),
      ),
    );
  }

  void onTapCamera(BuildContext context) {
    controller.openCamera();
  }

  void onSend(BuildContext context) {
    final fileName = controller.selectedFile?.name;
    debugPrint(fileName);
  }

  void onTapAdd(BuildContext context) {
    debugPrint(controller.messageLength.toString());
  }
}
