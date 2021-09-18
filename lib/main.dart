import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pill_pal/database.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/pages/cabinet/cabinet.dart';
import 'package:pill_pal/pages/calender/calender.dart';
import 'package:pill_pal/pages/home.dart';
import 'package:pill_pal/pages/landing/landing1.dart';
import 'package:pill_pal/pages/landing/landing2.dart';
import 'package:pill_pal/pages/landing/landing3.dart';
import 'package:pill_pal/pages/medicineAddPage/medicineAddPage.dart';
import 'package:pill_pal/pages/medicineEditPage/medicineEditPage.dart';
import 'package:pill_pal/pages/medicineItemPage/medicineItemPage.dart';
import 'package:pill_pal/pages/reminderAddPage/reminderAddPage.dart';
import 'package:pill_pal/theme.dart';
import 'package:pill_pal/util/databaseTestUtil.dart';
import 'package:pill_pal/util/notificationUtil.dart';
import 'package:timezone/data/latest.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  tz.initializeTimeZones();


  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  final medicineDao = database.medicineDao;
  final reminderDao = database.reminderDao;

  await addDatabaseDumpData(medicineDao, reminderDao);


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: defaultTheme,
    initialRoute: '/landing1',
    routes: {
      '/landing1': (context) => Landing1(),
      '/landing2': (context) => Landing2(),
      '/landing3': (context) => Landing3(),
      '/home': (context) => Home(),
      '/calender': (context) => Calender(reminderDao: reminderDao,),
      '/cabinet': (context) => Cabinet(medicineDao: medicineDao,),
      '/medicine_add': (context) => MedicineAddPage(medicineDao: medicineDao,),
    },
      onGenerateRoute: (settings) {
        if (settings.name == '/medicine_edit') {
          final med = settings.arguments as Medicine;
          return MaterialPageRoute(
            builder: (context) {
              return MedicineEditPage(medicineDao: medicineDao, med: med);
            },
          );
        }
        else if (settings.name == '/medicine_item') {
          final med = settings.arguments as Medicine;
          return MaterialPageRoute(
            builder: (context) {
              return MedicineItemPage(medicineDao: medicineDao,reminderDao: reminderDao ,med: med);
            },
          );
        }
        else if (settings.name == '/reminder_add') {
          final med = settings.arguments as Medicine;
          return MaterialPageRoute(
            builder: (context) {
              return ReminderAddPage(medicineDao: medicineDao, reminderDao: reminderDao, savedSelectedMedicine: med);
            },
          );
        }
        //print('Need to implement ${settings.name}');
        return null;
      }
  ));

}

