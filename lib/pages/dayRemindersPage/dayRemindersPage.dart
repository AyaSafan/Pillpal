import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_pal/components/pageSecondLayout.dart';
import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/dao/reminder_check_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/entities/reminder.dart';
import 'package:pill_pal/entities/reminderCheck.dart';
import 'package:pill_pal/pages/calender/components/dateCard.dart';
import 'package:pill_pal/theme.dart';
import 'package:pill_pal/util/notificationUtil.dart';




class DayRemindersPage extends StatefulWidget {
  const DayRemindersPage({Key? key,
    required this.medicineDao,
    required this.reminderDao,
    required this.reminderCheckDao,
    required this.dateTime,
    required this.reminders
  }) : super(key: key);

  final MedicineDao medicineDao;
  final ReminderDao reminderDao;
  final ReminderCheckDao reminderCheckDao;
  final DateTime dateTime;
  final List<Reminder> reminders;

  @override
  _DayRemindersPageState createState() => _DayRemindersPageState();
}

class _DayRemindersPageState extends State<DayRemindersPage> {

  Map timeMap = new Map();
  //[ [reminder object, bool checked or not, reminderCheck object if exists] ]
  final List<List<dynamic>> checkList = [];

  Medicine? med;


  Future<void> getCheckList() async{
    widget.reminders.forEach((reminder) {
      var scheduledDateTime = DateTime(widget.dateTime.year, widget.dateTime.month,widget.dateTime.day,
      reminder.dateTime.hour, reminder.dateTime.minute);
      widget.reminderCheckDao.findReminderByScheduledDate(scheduledDateTime, reminder.id??0).then((reminderCheck) {
        if(reminderCheck == null) {
          setState(() {
            checkList.add([reminder, false]);
          });
        }else{
          setState(() {
            checkList.add([reminder, true,reminderCheck ]);
          });
        }
      });
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    getCheckList().then((value) => null);
  }


  @override
  Widget build(BuildContext context) {
    final defaultPadding = MediaQuery. of(context). size. width / 20;
    setState(() {
      timeMap.clear();
    });

    return PageSecondLayout(
      showFAB: false,
      color: MyColors.Landing1,
      appBarRight:Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image.asset('assets/pill.png', height: 60, width: 80),
      ) ,
      containerChild: Padding(
        padding: EdgeInsets.fromLTRB(defaultPadding, defaultPadding,0,0),
        child: Column(
          children: [
            Row(
              children: [
                DateCard(widget.dateTime),
              ],
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: checkList.asMap().entries
                        .map((checkItem) {
                      return getReminderRow(checkItem.value, checkItem.key);
                    }).toList(),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }






  GestureDetector getReminderRow(List<dynamic> checkItem, int index) {

    Reminder reminder = checkItem[0];
    bool isChecked = checkItem[1];
    ReminderCheck? reminderCheck;
    reminderCheck = 2 < checkItem.length? checkItem[2]: null;

    // determine reminder check icon
    Widget icon = Icon( Icons.panorama_fish_eye,color: Colors.grey);
    var now = DateTime.now();
    var scheduledDateTime = DateTime(widget.dateTime.year, widget.dateTime.month,widget.dateTime.day,
        reminder.dateTime.hour, reminder.dateTime.minute);
    if(isChecked){
      icon = Icon(
        Icons.task_alt,
          color: MyColors.TealBlue,
      );
    }
    else if (scheduledDateTime.add(Duration(minutes: 5)).isBefore(now)){
      icon = Icon(
        Icons.highlight_off,
        color: MyColors.MiddleRed,
      );
    }

    // to show time only once
    var time = '${reminder.dateTime.hour < 10? '0': ''}${reminder.dateTime.hour}:'
        '${reminder.dateTime.minute < 10? '0': ''}${reminder.dateTime.minute}';
    setState(() {
      timeMap.containsKey(time)? timeMap[time]+=1 : timeMap[time] =1;
    });

    return GestureDetector(
      onTap: (){
        setState(() {
          med = null;
        });
        showModalBottomSheet<void>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQuery. of(context). size. width / 20),
          ),
          builder: (BuildContext context) {
            return Container(
              //height: 240,
              child:
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery. of(context). size. width / 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isChecked? Container(): TextButton.icon(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          textStyle: Theme.of(context).textTheme.bodyText2,
                        ),
                        label: Text('Take Dose'),
                        icon: Icon(
                          Icons.timelapse,
                        ),
                        onPressed: () {
                          if(med == null) {
                            widget.medicineDao.findMedicineById(reminder.medicineId).then((medicineItem) {
                              setState(() {
                                med = medicineItem;
                              });
                              takeDose(
                                  medicineItem, reminder, scheduledDateTime,
                                  now, index, context);

                            });
                          }else{
                            takeDose(
                                med, reminder, scheduledDateTime,
                                now, index, context);
                          }
                        },
                      ),
                      isChecked? Container(): TextButton.icon(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          textStyle: Theme.of(context).textTheme.bodyText2,
                        ),
                        label: Text('Check'),
                        icon: Icon(
                          Icons.task_alt,
                        ),
                        onPressed: () {
                          markDone(reminder, scheduledDateTime, now, index, context);
                        },
                      ),
                      !isChecked? Container(): TextButton.icon(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          textStyle: Theme.of(context).textTheme.bodyText2,
                        ),
                        label: Text('Uncheck'),
                        icon: Icon(
                          Icons.highlight_off,
                        ),
                        onPressed: () {
                          unDone(index, context);
                        },
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          textStyle: Theme.of(context).textTheme.bodyText2,
                        ),
                        label: Text('Medicine Info'),
                        icon: Icon(
                          Icons.medication,
                        ),
                        onPressed: () {
                          goToMedicinePage(reminder, context);
                        },
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          textStyle: Theme.of(context).textTheme.bodyText2,
                        ),
                        label: Text('Delete Reminder'),
                        icon: Icon(
                          Icons.delete,
                        ),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 75,
                    ),
                    child:
                    Text('${timeMap[time] ==1? time : ''}',
                      style: TextStyle(fontSize: 18, color: MyColors.TealBlue, fontWeight: FontWeight.bold),
                    ),

                  ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 3.0, color: MyColors.MiddleBlueGreen),
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8,),
                      icon,
                      SizedBox(width: 8,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${reminder.medicineName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            reminder.repeated? Text('Every ${DateFormat('EEEE').format(reminder.dateTime)}', style: TextStyle(fontSize: 15, color: Colors.black54),):
                            Text('Once', style: TextStyle(fontSize: 15, color: Colors.black54),),
                            isChecked? Text('${DateFormat('dd/MM/yyyy  kk:mm').format(reminderCheck!.checkedDateTime)}'):
                            reminder.label.isNotEmpty? Text('${reminder.label}',softWrap: true, style: TextStyle(fontSize: 16),): Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16,)
        ],
      ),
    );

  }

  void goToMedicinePage(Reminder reminder, BuildContext context) {
    if (med == null) {
      widget.medicineDao.findMedicineById(reminder.medicineId).then((medicineItem) {
        setState(() {
          med = medicineItem;
        });
        Navigator.pushNamed(context, '/medicine_item', arguments: medicineItem);
      });
    } else{
      Navigator.pushNamed(context, '/medicine_item', arguments: med);
    }
  }

  void unDone(int index, BuildContext context) {
    ReminderCheck check = checkList[index][2];
    widget.reminderCheckDao.deleteReminderCheck(check).then((value){
      setState(() {
        checkList[index][1] = false;
        checkList[index].removeAt(2);
      });
      Navigator.pop(context);
    });
  }

  void markDone(Reminder reminder, DateTime scheduledDateTime, DateTime now, int index, BuildContext context) {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int checkId = timestamp ~/ 1000 + timestamp % 1000;
    ReminderCheck check = ReminderCheck(id:checkId, reminderId: reminder.id ,scheduledDateTime: scheduledDateTime, checkedDateTime: now);
    widget.reminderCheckDao.insertReminderCheck(check).then((value) {
      setState(() {
        checkList[index][1] = true;
        2 < checkList[index].length
            ? checkList[index][2] = check
            : checkList[index].add(check);
      });
      Navigator.pop(context);
    });
  }

  void takeDose(Medicine? medicineItem, Reminder reminder, DateTime scheduledDateTime, DateTime now, int index, BuildContext context) {
    if(medicineItem!.supplyCurrent >= medicineItem.dose) {
        medicineItem = medicineItem.copyWith(
            supplyCurrent: medicineItem
                .supplyCurrent - medicineItem.dose);
      widget.medicineDao.updateMedicine(medicineItem).then((value) {
        markDone(reminder, scheduledDateTime, now, index, context);
      });
    }
    else{
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${medicineItem.name}supply is empty' )),
      );
    }

    if(medicineItem.supplyCurrent == 0){
      singleNotificationCallback( 0, '${medicineItem.name} Refill', 'current supply empty.',
          DateTime.now(), '${medicineItem.id}', sound: 'happy_tone_short').then((value) => null);
    }
    else if(medicineItem.supplyCurrent <= medicineItem.supplyMin){
      singleNotificationCallback( 0, '${medicineItem.name} Refill', 'current supply running out.',
          DateTime.now(), '${medicineItem.id}', sound: 'happy_tone_short').then((value) => null);
    }
  }



}
