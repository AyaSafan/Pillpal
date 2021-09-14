// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/entities/reminder.dart';

import 'package:pill_pal/pages/landing/landing1.dart';
import 'package:pill_pal/pages/landing/landing2.dart';
import 'package:pill_pal/pages/landing/landing3.dart';
import 'package:pill_pal/pages/home.dart';
import 'package:pill_pal/pages/calender/calender.dart';
import 'package:pill_pal/pages/cabinet/cabinet.dart';
import 'package:pill_pal/pages/medicineAddPage/medicineAddPage.dart';
import 'package:pill_pal/pages/medicineItemPage/medicineItemPage.dart';
import 'package:pill_pal/pages/reminderAddPage/reminderAddPage.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final database = await $FloorAppDatabase
//       .databaseBuilder('app_database.db')
//       .build();
//
//   runApp(FloorApp(dao));
// }

import 'package:pill_pal/database.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/entities/reminder.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  final medicineDao = database.medicineDao;

  await medicineDao.deleteAllMedicine();
  final med = Medicine(id:12, name: 'Paracetamol', pillColor: Colors.amber,
      //tags: ['After Breakfast', 'One hell of a very very long tag', 'Important!'],
      tags: ['After Breakfast'],
      desc: 'Paracetamol is a common painkiller used to treat aches and pain. '
          'It can also be used to reduce a high temperature.\n'
          ' It\'s available combined with other painkillers and anti-sickness medicines. '
          'It\'s also an ingredient in a wide range of cold and flu remedies.'
  );
  await medicineDao.insertMedicine(med);

  final reminderDao = database.reminderDao;
  await reminderDao.deleteAllReminders();
  final reminder = Reminder(medicineId: 12, label: 'first reminder');

  await reminderDao.insertReminder(reminder);
  final reminder2 = Reminder(medicineId: 12,  day: DateTime.monday, label: 'cyclic reminder', repeated: true);
  await reminderDao.insertReminder(reminder2);
  print('added');


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: MyColors.TealBlue,
      accentColor: MyColors.MiddleBlueGreen,
      errorColor: MyColors.MiddleRed,
      textTheme: const TextTheme(
        headline1: TextStyle( fontSize: 24, fontFamily: 'Raleway',color: Colors.black, ),
        headline2: TextStyle(fontSize: 18, letterSpacing: 2, fontFamily: 'Raleway',),
        bodyText2:TextStyle(fontSize: 16, fontFamily: 'Raleway', ),
      ),
    ),
    initialRoute: '/landing1',
    routes: {
      '/landing1': (context) => Landing1(),
      '/landing2': (context) => Landing2(),
      '/landing3': (context) => Landing3(),
      '/home': (context) => Home(),
      '/calender': (context) => Calender(reminderDao: reminderDao,),
      '/cabinet': (context) => Cabinet(medicineDao: medicineDao,),
      '/medicine_add': (context) => MedicineAddPage(),
      '/reminder_add': (context) => ReminderAddPage(),
      '/reminder_item': (context) => MedicineItemPage(),
    },
  ));

}
