import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pichu_oreo/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:pichu_oreo/utils/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMethods {
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static late User me;

  Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((token) async {
      if (token != null) {
        log('Push Token: $token');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? tk = prefs.getString('authorization');
        Map<String, dynamic> requestData = {
          "token": token,
        };
        await http.post(
          Uri.parse('$uri/api/auth/getRecipientToken'),
          body: jsonEncode(requestData),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${tk!}'
          },
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilist in foreground');
      log('Message data: $message');
      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
