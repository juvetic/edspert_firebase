import 'package:firebase/app/modules/push_notif/controllers/local_notification.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class PushNotifController extends GetxController {
  //TODO: Implement PushNotifController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    print("OnInut");
    getCurrentToken();
    configureBackgroundNotif();
    requestPermission();
    setupInteractedMessage();
    configureForegroundNotif();
  }



  void increment() => count.value++;

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  LocalNotification localNotification = LocalNotification();

  Future<String?> getCurrentToken() async {
    print('token');
    final token = await messaging.getToken();
    print(token);
    return token;
  }

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      // Navigator.pushNamed(context, '/chat',
      //   arguments: ChatArguments(message),
      // );
    }
  }

  void configureForegroundNotif() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        localNotification.showNotifOnForeground(message.notification);
      }
    });
  }

  configureBackgroundNotif() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  subscribeToTopic(String topic) async {
    // subscribe to topic on each app start-up
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  ubsubscribeToTopic(String topic) async {
    // subscribe to topic on each app start-up
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
