import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
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

  static Future initNotification({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@drawable/logo');

    const settings = InitializationSettings(
      android: android,
    );

    // When app is close
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.payload);
    }

    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });

    if (initScheduled) {
      tz.initializeTimeZones();
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
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

//Fonction pour envoyer des notifications avec une certaine marge de temps qu'on aura defini
  Future<void> showScheduledNotification(
          {int id = 0,
          String? title,
          String? body,
          String? payload,
          required int seconds}) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
        await _notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: payload,
      );

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
