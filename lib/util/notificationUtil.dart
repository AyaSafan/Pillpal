import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:pill_pal/main.dart';
import 'package:timezone/timezone.dart' as tz;

String currentTimezone = 'Unknown';


initializeNotifications() async {

  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  var IOS = new IOSInitializationSettings();

  var settings = new InitializationSettings(android: android, iOS: IOS);
  flutterLocalNotificationsPlugin.initialize(settings);

  currentTimezone = await FlutterNativeTimezone.getLocalTimezone();

}


Future singleNotification(
    int hashcode,
    String message,
    String subtext,
    tz.TZDateTime datetime,
    String? docId,
    {String? sound}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
        importance: Importance.max,
        priority: Priority.high
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );
  print(datetime);
  flutterLocalNotificationsPlugin.zonedSchedule(
        hashcode, message, subtext, datetime, platformChannelSpecifics,
        payload: docId,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
}

Future<void> singleNotificationCallback(int notificationId, String title, String subtext, DateTime dateTime) async {
var tzDateTime = tz.TZDateTime.from(dateTime, tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()),)
.add(Duration(seconds: 1));
await singleNotification( notificationId , title, subtext,
tzDateTime , '').then((value) => null);
}

Future repeatingNotification(
    int hashcode,
    String message,
    String subtext,
    tz.TZDateTime datetime,
    String? docId,
    {String? sound}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      'repeating channel id',
      'repeating channel name',
      'repeating description',
      importance: Importance.max,
      priority: Priority.high
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.zonedSchedule(
      hashcode, message, subtext, datetime, platformChannelSpecifics,
      payload: docId,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
}

Future<void> repeatingNotificationCallback(int notificationId, String title, String subtext, DateTime dateTime) async {
  var tzDateTime = tz.TZDateTime.from(dateTime, tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()),)
      .add(Duration(seconds: 1));
  await repeatingNotification( notificationId , title, subtext,
      tzDateTime , '').then((value) => null);
}



Future<void> cancelAlarm(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

void requestPermissions() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );
}