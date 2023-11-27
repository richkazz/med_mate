import 'dart:async';
import 'dart:io';
import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
      'notification action tapped with input: ${notificationResponse.input}',
    );
  }
}

class NotificationService {
  NotificationService();
  int id = 0;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  final didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  final selectNotificationStream = StreamController<String?>.broadcast();

  final platform =
      const MethodChannel('dexterx.dev/flutter_local_notifications_example');

  String portName = 'notification_send_port';
  String? selectedNotificationPayload;

  /// A notification action which triggers taking a drug
  final takeNowActionId = 'take_now_action_id_1';

  /// A notification action which triggers a skip of a drug
  String skipActionId = 'skip_action_id_3';

  /// A notification action which triggers a reschedule of a drug
  String rescheduleActionId = 'reschedule_action_id_3';

  bool _notificationsEnabled = true;
  Future<void> init() async {
    await _configureLocalTimeZone();

    final notificationAppLaunchDetails = !kIsWeb && Platform.isLinux
        ? null
        : await flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
    }

    const initializationSettingsAndroid =
        AndroidInitializationSettings('notificationicon');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == takeNowActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            } else if (notificationResponse.actionId == rescheduleActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            } else {
              selectNotificationStream.add(notificationResponse.payload);
            }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    await _isAndroidPermissionGranted();
    await _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  Future<void> _isAndroidPermissionGranted() async {
    final granted = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
    _notificationsEnabled = granted;
  }

  Future<void> _requestPermissions() async {
    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final grantedNotificationPermission =
        await androidImplementation?.requestNotificationsPermission();
    _notificationsEnabled = grantedNotificationPermission ?? false;
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      var x = 0;
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      var x = 0;
    });
  }

  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
  }

  Future<void> scheduleNotificationWithActions(
    Drug drug,
    int drugDosageTimeIndex,
    int dosageTimeId,
    DateTime scheduledTime,
  ) async {
    if (scheduledTime.isBefore(DateTime.now())) {
      return;
    }
    final androidNotificationDetails = getNotificationDetails(
      drug,
      drugDosageTimeIndex,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      dosageTimeId,
      'Medication reminder',
      'Take ${1} dose of ${drug.name} now.',
      _nextInstance(scheduledTime),
      NotificationDetails(
        android: androidNotificationDetails,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${drug.scheduleId}-$drugDosageTimeIndex',
    );
  }

  AndroidNotificationDetails getNotificationDetails(
    Drug drug,
    int drugDosageTimeIndex,
  ) {
    return AndroidNotificationDetails(
      'drug_schedule_${drug.scheduleId}',
      'drug_schedule',
      channelDescription: 'A reminder to take drug',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          skipActionId,
          'Skip',
          titleColor: AppColors.primaryColor,
        ),
        AndroidNotificationAction(
          takeNowActionId,
          'Take Now',
          titleColor: AppColors.primaryColor,
        ),
        AndroidNotificationAction(
          rescheduleActionId,
          'Reschedule',
          titleColor: AppColors.primaryColor,
          showsUserInterface: true,
        ),
      ],
    );
  }

  tz.TZDateTime _nextInstance(DateTime dateTime) {
    final now = tz.TZDateTime.from(dateTime, tz.local);
    return tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute);
  }

  Future<void> getActiveNotifications() async {
    try {
      final activeNotifications =
          await flutterLocalNotificationsPlugin.getActiveNotifications();
    } on PlatformException catch (error) {}
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(--id);
  }

  Future<void> cancelNotificationWithTag() async {
    await flutterLocalNotificationsPlugin.cancel(--id, tag: 'tag');
  }
}
