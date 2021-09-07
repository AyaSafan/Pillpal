// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/medicine_dao.dart';
import 'package:pill_pal/entities/medicine.dart';

import 'dao/reminder_dao.dart';
import 'package:pill_pal/entities/reminder.dart';

import 'dao/cyclic_reminder_dao.dart';
import 'package:pill_pal/entities/cyclic_reminder.dart';

import 'package:pill_pal/services/DateTimeConverter.dart';
import 'package:pill_pal/services/ListConverter.dart';
import 'package:pill_pal/services/ColorIntConverter.dart';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter, ListConverter, ColorIntConverter])
@Database(version: 1, entities: [Medicine, Reminder, CyclicReminder])
abstract class AppDatabase extends FloorDatabase {
  MedicineDao get medicineDao;
  ReminderDao get reminderDao;
  CyclicReminderDao get cyclicDao;
}

Future<AppDatabase> initDb() async {


  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();

  return database;
}





