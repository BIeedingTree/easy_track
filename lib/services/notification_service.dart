// TODOs: implement global navigator key, push home screen route with args, complete onDidReceiveNotificationResponse, make icon assets

import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestSoundPermission: true,
    requestBadgePermission: true,
  );

  const InitializationSettings initializationSettings =
      InitializationSettings(iOS: initializationSettingsDarwin);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // TODO
    },
  );
}

Future<void> showBACNotification({
  required double currentBAC,
  required double maxBAC,
}) async {
  final String status = currentBAC >= 0.08
      ? "High"
      : currentBAC >= 0.04
          ? "Moderate"
          : "Low";

  // TODO
  String assetName;
  if (currentBAC >= 0.08) {
    assetName = 'assets/icons/bac_high.png';
  } else if (currentBAC >= 0.04) {
    assetName = 'assets/icons/bac_moderate.png';
  } else {
    assetName = 'assets/icons/bac_low.png';
  }

  final Directory tempDir = await getTemporaryDirectory();
  final String fileName = assetName.split('/').last;
  final String filePath = '${tempDir.path}/$fileName';

  final byteData = await rootBundle.load(assetName);
  final file = File(filePath);
  await file.writeAsBytes(byteData.buffer.asUint8List());

  final attachment = DarwinNotificationAttachment(filePath);
  final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentSound: false,
    attachments: [attachment],
  );

  NotificationDetails platformDetails =
      NotificationDetails(iOS: iosDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    "🍻 BAC: ${currentBAC.toStringAsFixed(3)}",
    "Max: ${maxBAC.toStringAsFixed(3)} • Status: $status\nTap to add a drink",
    platformDetails,
  );
}
