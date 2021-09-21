
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:pill_pal/main.dart';
import 'package:timezone/timezone.dart' as tz;

String currentTimezone = 'Unknown';


initializeNotifications() async {

  var android = new AndroidInitializationSettings('@drawable/ic_stat_pillpal');
  var iOS = new IOSInitializationSettings();

  var settings = new InitializationSettings(android: android, iOS: iOS);
  flutterLocalNotificationsPlugin.initialize(settings, onSelectNotification: onSelectNotification);
  currentTimezone = await FlutterNativeTimezone.getLocalTimezone();
}


Future singleNotification(
    int hashcode,
    String message,
    String subtext,
    tz.TZDateTime datetime,
    String? payload,
    bool ongoing,
    String? sound) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'PillPal',
        'PillPal',
        'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        ongoing: ongoing,
        sound: RawResourceAndroidNotificationSound(sound),

    );
    var  iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: 'happy_tone.wav');
    var  macOSPlatformChannelSpecifics =
    MacOSNotificationDetails(sound: 'happy_tone.wav');
    var  platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: macOSPlatformChannelSpecifics,
    );
  flutterLocalNotificationsPlugin.zonedSchedule(
        hashcode, message, subtext, datetime, platformChannelSpecifics,
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
}

Future<void> singleNotificationCallback(int notificationId, String title, String subtext, DateTime dateTime, String? payload,
    {bool ongoing = true, String? sound = 'happy_tone'}) async {
  var tzDateTime = tz.TZDateTime.from(dateTime, tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()),)
  .add(Duration(seconds: 1));
  await singleNotification( notificationId , title, subtext,
  tzDateTime , payload, ongoing, sound).then((value) => null);
  //print('single $tzDateTime');
}



Future repeatingNotification(
    int hashcode,
    String message,
    String subtext,
    tz.TZDateTime datetime,
    String? payload,
    String? sound) async {

  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'PillPal',
    'PillPal',
    'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    ongoing: true,
    sound: RawResourceAndroidNotificationSound(sound),

  );
  var  iOSPlatformChannelSpecifics =
  IOSNotificationDetails(sound: 'happy_tone.wav');
  var  macOSPlatformChannelSpecifics =
  MacOSNotificationDetails(sound: 'happy_tone.wav');
  var  platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
    macOS: macOSPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.zonedSchedule(
      hashcode, message, subtext, datetime, platformChannelSpecifics,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
}

Future<void> repeatingNotificationCallback(int notificationId, String title, String subtext, DateTime dateTime, String? payload, {String? sound = 'happy_tone'}) async {
  var tzDateTime = tz.TZDateTime.from(dateTime, tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()),)
      .add(Duration(seconds: 1));
  await repeatingNotification( notificationId , title, subtext,
      tzDateTime , payload, sound).then((value) => null);
  //print('repeat $tzDateTime');
}



Future<void> cancelNotification(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
  //print('$id deleted');
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