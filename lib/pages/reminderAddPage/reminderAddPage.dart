import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/components/pageFirstLayout.dart';
import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/entities/reminder.dart';
import 'package:pill_pal/pages/medicineAddPage/components/customUnderLineInput.dart';
import 'package:pill_pal/pages/reminderAddPage/components/customDropdownMenu.dart';
import 'package:pill_pal/pages/reminderAddPage/components/dayChip.dart';
import 'package:pill_pal/theme.dart';
import 'package:pill_pal/util/notificationUtil.dart';


class ReminderAddPage extends StatefulWidget {
  const ReminderAddPage({Key? key,
      required this.reminderDao,
      required this.medicineDao,
      this.savedSelectedMedicine
  }) : super(key: key);


final ReminderDao reminderDao;
final MedicineDao medicineDao;
final Medicine? savedSelectedMedicine;

  @override
  _ReminderAddPageState createState() => _ReminderAddPageState();
}

class _ReminderAddPageState extends State<ReminderAddPage> {
  final _formKey = GlobalKey<FormState>();

  TimeOfDay _time = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  bool repeat = false;
  List<int> days = [];
  String label = '';
  List<Medicine> allMedicine = [];

  Medicine? savedSelectedMedicine;

    Future<List<Medicine>> getAllMedicine() async {
      final medicines = await widget.medicineDao.findAllMedicines();
      return medicines;
    }

    @override
    void initState() {
      super.initState();
      setState(() {
        savedSelectedMedicine = widget.savedSelectedMedicine;
      });
      getAllMedicine().then((value) {
        setState(() {
          allMedicine = value;
        });
      });
    }

    void _selectTime() async {
      final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: _time,
      );
      if (newTime != null) {
        setState(() {
          _time = newTime;
        });
      }
    }

    onSubmit() {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adding to Calender ...')),
      );
      registerReminders();
      Navigator.pop(context);
    }


    void registerReminders() {
      var notificationSubtext = label.isNotEmpty? label : '${savedSelectedMedicine?.name} dose ${savedSelectedMedicine?.dose} pills';
      //no day is marked
      if (days.isEmpty){
        int reminderId = DateTime.now().millisecondsSinceEpoch ~/ 1000 + Random().nextInt(1000);
        var dateTime = new DateTime.now();
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, _time.hour, _time.minute, dateTime.second ,dateTime.millisecond, dateTime.microsecond);
        Reminder reminder = Reminder(
            id: reminderId,
            medicineId: savedSelectedMedicine?.id ?? 0,
            day: dateTime.weekday,
            label: label,
            dateTime: dateTime,
            date: DateTime(dateTime.year, dateTime.month, dateTime.day).toString()
        );
        widget.reminderDao.insertReminder(reminder).then((value) => null);
        singleNotificationCallback( reminderId , '${savedSelectedMedicine?.name} Reminder', notificationSubtext,
            dateTime, '${savedSelectedMedicine?.id}').then((value) => null);

      }
      //repeat days are marked
      else if (repeat){
        days.forEach((day) {
          int reminderId = DateTime.now().millisecondsSinceEpoch ~/ 1000 + Random().nextInt(1000);
          var dateTime = new DateTime.now();
          while(dateTime.weekday!=day)
          {
            dateTime=dateTime.add(new Duration(days: 1));
          }
          dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, _time.hour, _time.minute, dateTime.second ,dateTime.millisecond, dateTime.microsecond);
          Reminder reminder = Reminder(
              repeated: true,
              id : reminderId,
              medicineId: savedSelectedMedicine?.id ?? 0,
              day: day,
              label: label,
              dateTime: dateTime
          );
          widget.reminderDao.insertReminder(reminder).then((value) => null);
          repeatingNotificationCallback( reminderId , '${savedSelectedMedicine?.name} Reminder', notificationSubtext,
              dateTime, '${savedSelectedMedicine?.id}').then((value) => null);
        });
      }
      //upcoming days are marked
      else{
        days.forEach((day) {
          int reminderId = DateTime.now().millisecondsSinceEpoch ~/ 1000 + Random().nextInt(1000);
          var dateTime = new DateTime.now();
          while(dateTime.weekday!=day)
          {
            dateTime=dateTime.add(new Duration(days: 1));
          }
          dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, _time.hour, _time.minute, dateTime.second ,dateTime.millisecond, dateTime.microsecond);
          Reminder reminder = Reminder(
              id : reminderId,
              medicineId: savedSelectedMedicine?.id ?? 0,
              day: day,
              label:label,
              dateTime: dateTime,
              date: DateTime(dateTime.year, dateTime.month, dateTime.day).toString()
          );
          widget.reminderDao.insertReminder(reminder).then((value) => null);

          singleNotificationCallback( reminderId , '${savedSelectedMedicine?.name} Reminder', notificationSubtext,
              dateTime, '${savedSelectedMedicine?.id}').then((value) => null);
        });
      }
    }


    @override
    Widget build(BuildContext context) {

      return PageFirstLayout(
        appBarTitle: 'Add Reminder',
        color: MyColors.Landing1,
        showFAB: false,
        containerChild:
        ListView(
          shrinkWrap: true,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _selectTime,
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: '${_time.format(context)}',
                        labelStyle: TextStyle(
                            color: Colors.black54
                        ),
                        suffixIcon: Icon(Icons.alarm),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey,),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24,),
                  Row(
                    children: [
                      Checkbox(
                        value: this.repeat,
                        onChanged: (bool? value) {
                          setState(() {
                            this.repeat = value ?? false;
                          });
                        },
                      ),
                      Text('Repeat')
                    ],
                  ),
                  Wrap(
                    runSpacing: 1,
                    spacing: 6,
                    children: [
                      DayChip(
                        label: 'Sun',
                        selected: days.contains(DateTime.sunday) ? true : false,
                        onSelected: (bool value) {
                          setState(() {
                            value ? days.add(DateTime.sunday) : days.remove(
                                DateTime.sunday);
                          });
                        },
                      ),
                      DayChip(
                        label: 'Mon',
                        selected: days.contains(DateTime.monday) ? true : false,
                        onSelected: (bool value) {
                          setState(() {
                            value ? days.add(DateTime.monday) : days.remove(
                                DateTime.monday);
                          });
                        },
                      ),
                      DayChip(
                        label: 'Tue',
                        selected: days.contains(DateTime.tuesday)
                            ? true
                            : false,
                        onSelected: (bool value) {
                          setState(() {
                            value ? days.add(DateTime.tuesday) : days.remove(
                                DateTime.tuesday);
                          });
                        },
                      ),
                      DayChip(
                        label: 'Wed',
                        selected: days.contains(DateTime.wednesday)
                            ? true
                            : false,
                        onSelected: (bool value) {
                          setState(() {
                            value ? days.add(DateTime.wednesday) : days.remove(
                                DateTime.wednesday);
                          });
                        },
                      ),
                      DayChip(
                        label: 'Thu',
                        selected: days.contains(DateTime.thursday)
                            ? true
                            : false,
                        onSelected: (bool value) {
                          setState(() {
                            value ? days.add(DateTime.thursday) : days.remove(
                                DateTime.thursday);
                          });
                        },
                      ),
                      DayChip(
                        label: 'Fri',
                        selected: days.contains(DateTime.friday) ? true : false,
                        onSelected: (bool value) {
                          setState(() {
                            value ? days.add(DateTime.friday) : days.remove(
                                DateTime.friday);
                          });
                        },
                      ),
                      DayChip(
                        label: 'Sat',
                        selected: days.contains(DateTime.saturday) ? true : false,
                        onSelected: (bool value) {
                          setState(() {
                            value ? days.add(DateTime.saturday) : days.remove(
                                DateTime.saturday);
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24,),
                  CustomUnderLineInput(
                    labelText: 'Label',
                    onSaved: (value) {
                      setState(() {
                        label = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 24,),
                  CustomDropdownMenu(formKey: _formKey, allMedicine: allMedicine,
                    selectedMedicine: widget.savedSelectedMedicine,
                    onSaved:(value){
                    // if condition is optimization if route is from med item and selected medicine didn't change
                    // if the saved medicine name here doesn't equal the nam from the dropdown
                    // if user changed to another med, then search for the med with that name and set it
                      if (savedSelectedMedicine?.name != value) {
                        allMedicine.forEach((element) {
                          if (element.name == value) {
                            setState(() {
                              savedSelectedMedicine = element;
                            });
                          }
                        });
                      }
                    },
                  ),
                  SizedBox(height: 32,),
                  Center(
                    child:
                    ElevatedButton.icon(
                      style: ButtonStyle(
                         // backgroundColor: MaterialStateProperty.all<
                         //     Color>(MyColors.MiddleRed),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )
                          )
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          onSubmit();
                        }
                      },
                      icon: Icon(Icons.add),
                      label:
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Text('Add to Calender'),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),


      );
    }
  }
