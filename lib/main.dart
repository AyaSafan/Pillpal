import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/dao/reminder_check_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/database.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/pages/Home/home.dart';
import 'package:pill_pal/pages/cabinet/cabinet.dart';
import 'package:pill_pal/pages/calender/calender.dart';
import 'package:pill_pal/pages/landing/landing1.dart';
import 'package:pill_pal/pages/landing/landing2.dart';
import 'package:pill_pal/pages/landing/landing3.dart';
import 'package:pill_pal/pages/medicineAddPage/medicineAddPage.dart';
import 'package:pill_pal/pages/medicineEditPage/medicineEditPage.dart';
import 'package:pill_pal/pages/medicineItemPage/medicineItemPage.dart';
import 'package:pill_pal/pages/reminderAddPage/reminderAddPage.dart';
import 'package:pill_pal/pages/splash.dart';
import 'package:pill_pal/theme.dart';
import 'package:pill_pal/util/databaseTestUtil.dart';
import 'package:pill_pal/util/notificationUtil.dart';
import 'package:timezone/data/latest.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

Future onSelectNotification(payload) async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final route = payload.toString().split(" ")[0];
  final value = payload.toString().split(" ")[1];
  if (route == 'medicine') {
    final medicineDao = database.medicineDao;
    Medicine? med = await medicineDao.findMedicineById(int.parse(value));
    await Navigator.pushNamedAndRemoveUntil(
        MyApp.navigatorKey.currentState!.context,
        '/medicine_item',
        ModalRoute.withName('/home'),
        arguments: med);
  } else {
    DateTime? dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(value));
    await Navigator.pushNamedAndRemoveUntil(
        MyApp.navigatorKey.currentState!.context,
        '/calender', ModalRoute.withName('/home'),
        arguments: dateTime);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  tz.initializeTimeZones();

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final medicineDao = database.medicineDao;
  final reminderDao = database.reminderDao;
  final reminderCheckDao = database.reminderCheckDao;

  await addDatabaseDumpData(medicineDao, reminderDao);


  runApp(MyApp(
    reminderDao: reminderDao,
    medicineDao: medicineDao,
    reminderCheckDao: reminderCheckDao,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {Key? key,
      required this.medicineDao,
      required this.reminderDao,
      required this.reminderCheckDao})
      : super(key: key);

  final MedicineDao medicineDao;
  final ReminderDao reminderDao;
  final ReminderCheckDao reminderCheckDao;

  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: defaultTheme,
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => Splash(),
          '/landing1': (context) => Landing1(),
          '/landing2': (context) => Landing2(),
          '/landing3': (context) => Landing3(),
          '/home': (context) => Home(
                reminderDao: reminderDao,
                reminderCheckDao: reminderCheckDao,
              ),
          '/cabinet': (context) => Cabinet(
                medicineDao: medicineDao,
              ),
          '/medicine_add': (context) => MedicineAddPage(
                medicineDao: medicineDao,
              ),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/calender') {
            final passedDay = settings.arguments as DateTime;
            return MaterialPageRoute(
              builder: (context) {
                return Calender(
                  medicineDao: medicineDao,
                  reminderDao: reminderDao,
                  reminderCheckDao: reminderCheckDao,
                  passedDay: passedDay,
                );
              },
            );
          } else if (settings.name == '/medicine_edit') {
            final med = settings.arguments as Medicine;
            return MaterialPageRoute(
              builder: (context) {
                return MedicineEditPage(medicineDao: medicineDao, med: med);
              },
            );
          } else if (settings.name == '/medicine_item') {
            final med = settings.arguments as Medicine;
            return MaterialPageRoute(
              builder: (context) {
                return MedicineItemPage(
                    medicineDao: medicineDao,
                    reminderDao: reminderDao,
                    med: med);
              },
            );
          } else if (settings.name == '/reminder_add') {
            final med = settings.arguments as Medicine;
            return MaterialPageRoute(
              builder: (context) {
                return ReminderAddPage(
                    medicineDao: medicineDao,
                    reminderDao: reminderDao,
                    savedSelectedMedicine: med);
              },
            );
          }
          //print('Need to implement ${settings.name}');
          return null;
        });
  }
}
