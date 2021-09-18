import 'package:flutter/material.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/entities/reminder.dart';

Future<void> addDatabaseDumpData(medicineDao, reminderDao) async {

  await medicineDao.deleteAllMedicine();
  final med = Medicine(id:12, name: 'Paracetamol', pillColor: Colors.amber,
      //tags: ['After Breakfast', 'One hell of a very very long tag', 'Important!'],
      tags: ['After Breakfast'],
      desc: 'Paracetamol is a common painkiller used to treat aches and pain. '
          'It can also be used to reduce a high temperature.\n'
          ' It\'s available combined with other painkillers and anti-sickness medicines. '
          'It\'s also an ingredient in a wide range of cold and flu remedies.',
      pillShape: 'a very long vivid description of shape',
      supplyCurrent: 5,
      supplyMin: 3
  );
  await medicineDao.insertMedicine(med);
  await medicineDao.insertMedicine(Medicine(name: 'a'));
  await medicineDao.insertMedicine(Medicine(name: 'b'));
  await medicineDao.insertMedicine(Medicine(name: 'c'));
  await medicineDao.insertMedicine(Medicine(name: 'd'));

  await reminderDao.deleteAllReminders();
  final reminder = Reminder(medicineId: 12, label: 'first reminder', dateTime: DateTime.now());

  await reminderDao.insertReminder(reminder);
  final reminder2 = Reminder(medicineId: 12,  day: DateTime.monday, label: 'cyclic reminder', repeated: true, dateTime: DateTime.now());
  await reminderDao.insertReminder(reminder2);
  print('added');


}