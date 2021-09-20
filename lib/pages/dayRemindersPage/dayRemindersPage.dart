import 'package:flutter/material.dart';
import 'package:pill_pal/components/pageSecondLayout.dart';
import 'package:pill_pal/dao/reminder_check_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/entities/reminder.dart';
import 'package:pill_pal/entities/reminderCheck.dart';
import 'package:pill_pal/pages/calender/components/dateCard.dart';
import 'package:pill_pal/theme.dart';


class DayRemindersPage extends StatefulWidget {
  const DayRemindersPage({Key? key,
    required this.reminderDao,
    required this.reminderCheckDao,
    required this.dateTime,
    required this.reminders
  }) : super(key: key);

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: checkList.asMap().entries
                      .map((checkItem) {
                    return getReminderRow(checkItem.value, checkItem.key);
                  }).toList(),
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


    Widget icon = Icon(
      Icons.panorama_fish_eye,
        color: Colors.grey,
    );

    var scheduledDateTime = DateTime(widget.dateTime.year, widget.dateTime.month,widget.dateTime.day,
        reminder.dateTime.hour, reminder.dateTime.minute);

    if(isChecked){
      icon = Icon(
        Icons.task_alt,
          color: MyColors.TealBlue,
      );
    }
    else if (scheduledDateTime.add(Duration(minutes: 5)).isBefore(DateTime.now())){
      icon = Icon(
        Icons.highlight_off,
        color: MyColors.MiddleRed,
      );
    }

    var time = '${reminder.dateTime.hour < 10? '0': ''}${reminder.dateTime.hour}:'
        '${reminder.dateTime.minute < 10? '0': ''}${reminder.dateTime.minute}';
    setState(() {
      timeMap.containsKey(time)? timeMap[time]+=1 : timeMap[time] =1;
    });
    return GestureDetector(
      onTap: (){},
      child: Row(
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
              SizedBox(height: 50,),
            ],
          ),
          Container(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('  ${reminder.medicineName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text('  ${reminder.label}', style: TextStyle(fontSize: 16),)
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
