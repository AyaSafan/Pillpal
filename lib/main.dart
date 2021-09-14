// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
import 'package:pill_pal/entities/medicine.dart';
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

void main() => runApp(MaterialApp(
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
        '/calender': (context) => Calender(),
        '/cabinet': (context) => Cabinet(),
        '/medicine_add': (context) => MedicineAddPage(),
        '/reminder_add': (context) => ReminderAddPage(),
        '/reminder_item': (context) => MedicineItemPage(),
      },
      // onGenerateRoute: (settings) {
      //   if (settings.name ==  '/reminder_item') {
      //
      //     final med = settings.arguments as Medicine;
      //
      //     return MaterialPageRoute(
      //     builder: (context) {
      //     return MedicineItemPage(med: med);
      //     },
      //   );
      // }}

    ));
