// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:floor/floor.dart';
import 'package:pill_pal/database.dart';

import 'package:flutter/material.dart';
import 'pages/landing1.dart';
import 'pages/landing2.dart';
import 'pages/landing3.dart';
import 'pages/home.dart';
import 'pages/calender.dart';
import 'pages/cabinet.dart';


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
  initialRoute: '/landing1',
  routes: {
    '/landing1': (context) => Landing1(),
    '/landing2': (context) => Landing2(),
    '/landing3': (context) => Landing3(),
    '/home': (context) => Home(),
    '/calender': (context) => Calender(),
    '/cabinet': (context) => Cabinet(),

  },
));
