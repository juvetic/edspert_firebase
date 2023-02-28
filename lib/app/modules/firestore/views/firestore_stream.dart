import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/firestore_controller.dart';
import '../models/chat_item.dart';
import '../widgets/chat_item_widget.dart';
import '../widgets/input_chat.dart';

/// C is a generic class can referred to other class based on assignment
/// In this case other engineer can create new controller but must extends
/// from [DiscussionController]. So, you will not double lifecycle execution.
class FirestoreStream extends StatelessWidget {
  final controller = Get.put(FirestoreController());
  static const routeName = '/discussion';

  FirestoreStream({super.key});

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
      title: const Text('Diskusi Soal Stream'),
      actions: [
        IconButton(
          onPressed: controller.readData,
          icon: Icon(Icons.refresh),
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
    return GetBuilder<FirestoreController>(builder: (c) {
      return StreamBuilder(
          stream: controller
              .getCollection()
              .orderBy('message', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.reversed.length,
              reverse: true,
              itemBuilder: (context, index) {
                final chat =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final chatItem = ChatItem(
                  content: chat['message'],
                  image: chat['image'],
                  id: 1,
                  name: "Name",
                  dateTime: DateTime.now(),
                );
                return ChatItemWidget(chat: chatItem);
              },
            );
          });
    });
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
    controller.pickImage(ImageSource.camera);
  }

  void onSend(BuildContext context) {
    final fileName = controller.selectedFile?.name;
    debugPrint(fileName);
  }

  void onTapAdd(BuildContext context) {
    debugPrint(controller.messageLength.toString());
  }
}
