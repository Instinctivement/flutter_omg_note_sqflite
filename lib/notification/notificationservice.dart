import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_omg_note_sqflite/models/task.dart';
import 'package:flutter_omg_note_sqflite/views/notified_page.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future initNotification({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@drawable/logo');

    const settings = InitializationSettings(
      android: android,
    );

    // When app is close
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.payload);
    }

    // await _notifications.initialize(settings,
    //     onSelectNotification: (payload) async {
    //   onNotifications.add(payload);
    // });

    await _notifications.initialize(settings,
        onSelectNotification: selectNotification);

    if (initScheduled) {
      _configureLocalTimezone();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.max,
        icon: '@drawable/logo',
      ),
    );
  }

//Fonction pour directement envoyer une notification apres un gesture detector par exemple
  Future<void> showSimpleNotification({
    int id = 0,
    String? title,
    String? body,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: title,
      );

//Fonction pour envoyer des notifications avec une certaine marge de temps qu'on aura defini
  Future<void> showScheduledNotification(
    int hour,
    int minutes,
    Task task, {
    int id = 0,
  }) async {
    _notifications.zonedSchedule(
      task.id!.toInt(),
      task.title,
      task.note,
      _convertTime(hour, minutes),
      await _notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidAllowWhileIdle: true,
      payload: "${task.title}|" "${task.note}|",
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }

  Future selectNotification(String? payload) async {
    if (payload != "Changement de thème") {
      Get.to(() => NotifiedPage(label: payload));
    }
  }

//Fonction pour envoyer des notifications chaques jours à une heure bien precise
  Future<void> showDailyNotification(
          {int id = 0,
          String? title,
          String? body,
          String? payload,
          required DateTime time}) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        _scheduleDaily(const Time(8)),
        await _notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.time,
      );

//Fonction pour envoyer des notifications à des jours precis dans la semaine
  Future<void> showWeeklyNotification(
          {int id = 0,
          String? title,
          String? body,
          String? payload,
          required DateTime time}) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        _scheduleWeekly(const Time(8),
            days: [DateTime.monday, DateTime.tuesday]),
        await _notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);

    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
    tz.TZDateTime scheduledDate = _scheduleDaily(time);

    while (!days.contains(scheduledDate.weekday)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
