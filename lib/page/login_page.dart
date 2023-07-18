// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_chat_sample/component/widgets.dart';
import 'package:sendbird_chat_sample/main.dart';
import 'package:sendbird_chat_sample/notifications/firebase_manager.dart';
import 'package:sendbird_chat_sample/notifications/local_notifications_manager.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController textEditingController;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController()
      ..text = 'userId${Random().nextInt(1000)}';

    FirebaseManager.listenOnForegroundMessage();
    LocalNotificationsManager.initialize();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Widgets.pageTitle('Sendbird Chat Sample for Flutter')),
            const Text('v$sampleVersion', style: TextStyle(fontSize: 12.0)),
          ],
        ),
        actions: const [],
      ),
      body: _loginBox(),
    );
  }

  Widget _loginBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Widgets.textField(textEditingController, 'User ID'),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () async {
              if (textEditingController.value.text.isEmpty) {
                return;
              }

              await SendbirdChat.connect(textEditingController.value.text);
              if (SendbirdChat.getPendingPushToken() != null) {
                await FirebaseManager.registerPushToken();
              }

              Get.toNamed('/main')?.then((value) async {
                await SendbirdChat.disconnect();
              });
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
