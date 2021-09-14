import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
import 'package:pill_pal/components/curvedContainer.dart';

import 'package:pill_pal/components/FAB.dart';
import 'package:pill_pal/components/pageFirstLayout.dart';


import 'package:pill_pal/entities/reminder.dart';

import 'package:pill_pal/database.dart';
import 'package:pill_pal/entities/medicine.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AppDatabase database;

  @override
  void initState() {
    super.initState();

    initDb().then((database) async {
      this.database = database;


      final medicineDao = database.medicineDao;
      await medicineDao.deleteAllMedicine();
      final med = Medicine(id:12, name: 'Paracetamol', pillColor: Colors.amber, tags: ['After Breakfast', 'One hell of a very very long tag', 'Important!']);
      await medicineDao.insertMedicine(med);

      final reminderDao = database.reminderDao;
      await reminderDao.deleteAllReminders();
      final reminder = Reminder(medicineId: 12, label: 'first reminder');

      await reminderDao.insertReminder(reminder);
      final reminder2 = Reminder(medicineId: 12,  day: DateTime.monday, label: 'cyclic reminder', repeated: true);
      await reminderDao.insertReminder(reminder2);
      print ('added');

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageFirstLayout(
      appBarTitle: 'PillPal',
      appBarRight:Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image.asset('assets/pill.png', height: 60, width: 80),
      ) ,
      containerChild:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: Theme.of(context).textTheme.headline2,
                  ),
                  label: Text('My Calender'),
                  icon: Icon(
                    Icons.event_outlined,
                    color: MyColors.MiddleRed,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/calender');
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: Theme.of(context).textTheme.headline2,
                  ),
                  label: Text('My Cabinet'),
                  icon: Icon(Icons.medical_services_outlined,
                      color: MyColors.TealBlue, size: 30),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cabinet');
                  },
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 2,
                  height: 32,
                ),

              ],
            ),
    );
  }
}
