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
  const ReminderAddPage(
      {Key? key,
      required this.medicineDao,
      required this.reminderDao,
      this.savedSelectedMedicine})
      : super(key: key);

  final MedicineDao medicineDao;
  final ReminderDao reminderDao;
  final Medicine? savedSelectedMedicine;

  @override
  _ReminderAddPageState createState() => _ReminderAddPageState();
}

class _ReminderAddPageState extends State<ReminderAddPage> {
  final _formKey = GlobalKey<FormState>();

  TimeOfDay _time =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute + 1);
  bool repeat = false;
  bool isEveryday = false;
  List<int> days = [];
  String label = '';
  List<Medicine> allMedicine = [];

  //bool rebuiltHomeFlag = false;

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
    registerReminders();
    Navigator.pushNamedAndRemoveUntil(context, '/calender',  ModalRoute.withName('/home'));
    //Navigator.pop(context);
    //goToHome();
  }
  //
  // void goToHome() {
  //   if (rebuiltHomeFlag) {
  //     Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  //   } else {
  //     Navigator.pop(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return PageFirstLayout(
      appBarTitle: 'Add Reminder',
      color: MyColors.Landing1,
      appBarRight: IconButton(
        icon: Icon(Icons.check),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              onSubmit();
            }
          }
      ),
      containerChild: ListView(
        shrinkWrap: true,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomDropdownMenu(
                  formKey: _formKey,
                  allMedicine: allMedicine,
                  selectedMedicine: widget.savedSelectedMedicine,
                  onSaved: (value) {
                    // if condition is optimization --> if route is from med item and selected medicine didn't change
                    // if the saved medicine name here doesn't equal the name from the dropdown
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
                SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: _selectTime,
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: '${_time.format(context)}',
                      labelStyle: TextStyle(color: Colors.black54),
                      suffixIcon: Icon(Icons.alarm),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
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
                        Text('Repeat'),
                      ],
                    ),
                    SizedBox(width: 8,),
                    Row(
                      children: [
                        Checkbox(
                          value: this.isEveryday,
                          onChanged: (bool? value) {
                            setState(() {
                              this.isEveryday = value ?? false;
                            });
                            if(isEveryday){
                              setState(() {
                                days = [1,2,3,4,5,6,7];
                              });
                            }else{
                              setState(() {
                                days.clear();
                              });
                            }
                            },
                        ),
                        Text('Everyday'),
                      ],
                    )
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
                          value
                              ?  setState(() {
                                days.add(DateTime.sunday);
                                isEveryday = days.length == 7;
                                })
                              : setState((){
                                days.remove(DateTime.sunday);
                                isEveryday = false;
                              });
                      },
                    ),
                    DayChip(
                      label: 'Mon',
                      selected: days.contains(DateTime.monday) ? true : false,
                      onSelected: (bool value) {
                        value
                            ?  setState(() {
                          days.add(DateTime.monday);
                          isEveryday = days.length == 7;
                        })
                            : setState((){
                          days.remove(DateTime.monday);
                          isEveryday = false;
                        });
                      },
                    ),
                    DayChip(
                      label: 'Tue',
                      selected: days.contains(DateTime.tuesday) ? true : false,
                      onSelected: (bool value) {
                        value
                            ?  setState(() {
                          days.add(DateTime.tuesday);
                          isEveryday = days.length == 7;
                        })
                            : setState((){
                          days.remove(DateTime.tuesday);
                          isEveryday = false;
                        });
                      },
                    ),
                    DayChip(
                      label: 'Wed',
                      selected:
                          days.contains(DateTime.wednesday) ? true : false,
                      onSelected: (bool value) {
                        value
                            ?  setState(() {
                          days.add(DateTime.wednesday);
                          isEveryday = days.length == 7;
                        })
                            : setState((){
                          days.remove(DateTime.wednesday);
                          isEveryday = false;
                        });
                      },
                    ),
                    DayChip(
                      label: 'Thu',
                      selected: days.contains(DateTime.thursday) ? true : false,
                      onSelected: (bool value) {
                        value
                            ?  setState(() {
                          days.add(DateTime.thursday);
                          isEveryday = days.length == 7;
                        })
                            : setState((){
                          days.remove(DateTime.thursday);
                          isEveryday = false;
                        });
                      },
                    ),
                    DayChip(
                      label: 'Fri',
                      selected: days.contains(DateTime.friday) ? true : false,
                      onSelected: (bool value) {
                        value
                            ?  setState(() {
                          days.add(DateTime.friday);
                          isEveryday = days.length == 7;
                        })
                            : setState((){
                          days.remove(DateTime.friday);
                          isEveryday = false;
                        });
                      },
                    ),
                    DayChip(
                      label: 'Sat',
                      selected: days.contains(DateTime.saturday) ? true : false,
                      onSelected: (bool value) {
                        value
                            ?  setState(() {
                          days.add(DateTime.saturday);
                          isEveryday = days.length == 7;
                        })
                            : setState((){
                          days.remove(DateTime.saturday);
                          isEveryday = false;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                CustomUnderLineInput(
                  labelText: 'Label',
                  onSaved: (value) {
                    setState(() {
                      label = value ?? '';
                    });
                  },
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void registerReminders() {
    var notificationSubtext = label.isNotEmpty
        ? label
        : 'Dose ${savedSelectedMedicine?.dose} pills';
    //no day is marked
    if (days.isEmpty) {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      int reminderId = timestamp ~/ 1000 + timestamp % 1000;
      var dateTime = new DateTime.now();
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
          _time.hour, _time.minute);
      Reminder reminder = Reminder(
          id: reminderId,
          medicineId: savedSelectedMedicine?.id ?? 0,
          medicineName: savedSelectedMedicine?.name ?? '',
          day: dateTime.weekday,
          label: label,
          dateTime: dateTime,
          //single time reminders are collected by date
          date:
              DateTime(dateTime.year, dateTime.month, dateTime.day).toString());
      widget.reminderDao.insertReminder(reminder).then((value) => null);
      singleNotificationCallback(
              reminderId,
              '${savedSelectedMedicine?.name} Reminder',
              notificationSubtext,
              dateTime,
              'reminder ${dateTime.millisecondsSinceEpoch}')
          .then((value) => null);
    }
    //repeat days are marked
    else if (repeat) {
      if(isEveryday){
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        int reminderId = timestamp ~/ 1000 + timestamp % 1000;
        final now = new DateTime.now();
        var dateTime = now;
        //today is monday ..if time chosen already passed on that monday.. schedule monday next week
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            _time.hour, _time.minute);
        Reminder reminder = Reminder(
            repeated: true,
            id: reminderId,
            medicineId: savedSelectedMedicine?.id ?? 0,
            medicineName: savedSelectedMedicine?.name ?? '',
            day: 0,
            label: label,
            dateTime: dateTime);
        widget.reminderDao.insertReminder(reminder).then((value) => null);
        everydayNotificationCallback(
            reminderId,
            '${savedSelectedMedicine?.name} Reminder',
            notificationSubtext,
            dateTime,
            'reminder ${dateTime.millisecondsSinceEpoch}')
            .then((value) => null);

      }
      else{
        days.forEach((day) {
          int timestamp = DateTime.now().millisecondsSinceEpoch;
          int reminderId = timestamp ~/ 1000 + timestamp % 1000;
          final now = new DateTime.now();
          var dateTime = now;
          while (dateTime.weekday != day) {
            dateTime = dateTime.add(new Duration(days: 1));
          }
          //today is monday ..if time chosen already passed on that monday.. schedule monday next week
          if (dateTime.isBefore(DateTime.now())) {
            dateTime = dateTime.add(Duration(days: 7));
          }
          dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
              _time.hour, _time.minute);
          Reminder reminder = Reminder(
              repeated: true,
              id: reminderId,
              medicineId: savedSelectedMedicine?.id ?? 0,
              medicineName: savedSelectedMedicine?.name ?? '',
              day: day,
              label: label,
              dateTime: dateTime);
          widget.reminderDao.insertReminder(reminder).then((value) => null);
          repeatingNotificationCallback(
              reminderId,
              '${savedSelectedMedicine?.name} Reminder',
              notificationSubtext,
              dateTime,
              'reminder ${dateTime.millisecondsSinceEpoch}')
              .then((value) => null);
        });
      }

    }
    //upcoming days are marked
    else {
      days.forEach((day) {
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        int reminderId = timestamp ~/ 1000 + timestamp % 1000;
        final now = new DateTime.now();
        var dateTime = now;
        while (dateTime.weekday != day) {
          dateTime = dateTime.add(new Duration(days: 1));
        }
        //today is monday ..if time chosen already passed on that monday.. schedule monday next week
        if (dateTime.isBefore(DateTime.now())) {
          dateTime = dateTime.add(Duration(days: 7));
        }
        print(dateTime);
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            _time.hour, _time.minute);
        Reminder reminder = Reminder(
            id: reminderId,
            medicineId: savedSelectedMedicine?.id ?? 0,
            medicineName: savedSelectedMedicine?.name ?? '',
            day: day,
            label: label,
            dateTime: dateTime,
            //single time reminders are collected by date
            date: DateTime(dateTime.year, dateTime.month, dateTime.day)
                .toString());
        widget.reminderDao.insertReminder(reminder).then((value) => null);

        singleNotificationCallback(
                reminderId,
                '${savedSelectedMedicine?.name} Reminder',
                notificationSubtext,
                dateTime,
                'reminder ${dateTime.millisecondsSinceEpoch}')
            .then((value) => null);
      });
    }
  }
}
