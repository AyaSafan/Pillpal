import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/pages/medicineItemPage/components/CustomCard.dart';
import 'package:pill_pal/theme.dart';
import 'package:pill_pal/util/notificationUtil.dart';

class MedicineItemPage extends StatefulWidget {
  const MedicineItemPage({Key? key,
    required this.medicineDao,
    required this.reminderDao,
    required this.med
  }) : super(key: key);


  final MedicineDao medicineDao;
  final ReminderDao reminderDao;
  final Medicine med;

  @override
  _MedicineItemPageState createState() => _MedicineItemPageState();
}

class _MedicineItemPageState extends State<MedicineItemPage> {

  Medicine medicineItem = Medicine(name: '');

  void initState() {
    super.initState();
    setState(() {
      medicineItem = widget.med;
    });
  }


  @override
  Widget build(BuildContext context) {
    final defaultPadding = MediaQuery. of(context). size. width / 20;
    var image = 'assets/medicineBottle.png';
    if(medicineItem.pillShape == 'assets/capsule.png'){
      image = 'assets/capsuleGroup.png';
    }else if(medicineItem.pillShape == 'assets/roundedpill.png'){
      image = 'assets/roundGroup.png';
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: (){
                showModalBottomSheet<void>(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultPadding),
                  ),
                  builder: buildBottomSheet,
                );
              },
            ),
          ],
        ),   //showFAB: false,

      body: ListView(
        children: [
          Center(
            child:Stack(
              children: [
                Container(height: 225, width: 150, color:medicineItem.pillColor,),
                Image.asset(image, height: 225, width: 150,)
              ],
            ),
          ),
          SizedBox(height: 32,),
          Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${medicineItem.name}', style: Theme.of(context).textTheme.headline6),
                      SizedBox(height: 8,),
                      medicineItem.desc.isNotEmpty ? Column(
                        children: [
                          Text(
                            medicineItem.desc,
                            softWrap: true,
                            //style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(height: 16,),
                        ],
                      ) : SizedBox(),
                      Wrap(
                        runSpacing: 2,
                        spacing: 5,
                        children: medicineItem.tags.map((tag) =>
                            Chip(
                              label: Text('$tag', ),
                              backgroundColor: MyColors.TealBlue.withOpacity(0.5),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            )
                        ).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16,),
                Row(
                  children: [
                    CustomCard(
                      title: 'Available',
                      data: '${medicineItem.supplyCurrent} pills',
                      icon: Icon(
                        Icons.assignment_turned_in,
                        color: MyColors.TealBlue,
                      ),
                      color: MyColors.TealBlue,
                    ),
                    CustomCard(
                      title: 'Alert on',
                      data: '${medicineItem.supplyMin} pills',
                      icon: Icon(
                        Icons.assignment_late,
                        color: Color(0xffda4625),
                      ),
                      color: Color(0xffda4625),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomCard(
                      title: 'Dose',
                      data: '${medicineItem.dose} pills/dose',
                      icon: Icon(
                        Icons.timelapse,
                        color: MyColors.MiddleRed,
                      ),
                      color: MyColors.MiddleRed,
                    ),
                    CustomCard(
                      title: 'Strength',
                      data: '${medicineItem.capSize} mg',
                      icon: Icon(
                        Icons.hourglass_bottom,
                        color: Colors.purple,
                      ),
                      color: Colors.purple,
                    ),
                  ],
                ),
                SizedBox(height: 32,),
              ],
            ),
          ),

        ],
      )
    );
  }

  Widget buildBottomSheet(BuildContext context) {
      return Container(
        child:
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery. of(context). size. width / 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: Theme.of(context).textTheme.bodyText1,
                  ),
                  label: Text('Take Dose'),
                  icon: Icon(
                    Icons.timelapse,
                  ),
                  onPressed: () {
                    takeDose(context);
                  },
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: Theme.of(context).textTheme.bodyText1,
                  ),
                  label: Text('Add Reminder'),
                  icon: Icon(
                    Icons.notification_add,
                  ),
                  onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/reminder_add', arguments: medicineItem);
                  },
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: Theme.of(context).textTheme.bodyText1,
                  ),
                  label: Text('Edit Pill'),
                  icon: Icon(
                    Icons.edit,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/medicine_edit', arguments: medicineItem);
                  },
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: Theme.of(context).textTheme.bodyText1,
                  ),
                  label: Text('Delete Pill'),
                  icon: Icon(
                    Icons.delete,
                  ),
                  onPressed: () {
                    showDeleteDialog(context);

                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child:
            Text('${medicineItem.name} will be permanently deleted.', style: TextStyle(fontSize: 14),)
          ),
          actions: [
            TextButton(
              child: Text("Delete", style: TextStyle(fontSize: 14),),
              onPressed: () {
                onDeleteMedicine(context);
              },

            ),
            TextButton(
              child: Text("Cancel", style: TextStyle(fontSize: 14),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void onDeleteMedicine(BuildContext context) {
    widget.reminderDao.findReminderByMedicineId(medicineItem.id ?? 0).then((reminders) {
      reminders.forEach((reminder) {
        cancelNotification(reminder.id ?? 0);
        widget.reminderDao.deleteReminder(reminder);
      });
      widget.medicineDao.deleteMedicine(medicineItem).then((value) => null);
      Navigator.popUntil(context, ModalRoute.withName('/cabinet'));
    });

  }

  void takeDose(BuildContext context) {
    if(medicineItem.supplyCurrent >= medicineItem.dose) {
      setState(() {
        medicineItem = medicineItem.copyWith(
            supplyCurrent: medicineItem
                .supplyCurrent - medicineItem.dose);
      });
      widget.medicineDao.updateMedicine(medicineItem).then((value) {
          Navigator.pop(context);
      });
    }
    else{
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${medicineItem.name} supply is empty' )),
      );
    }

    if(medicineItem.supplyCurrent == 0){
      singleNotificationCallback( 1, '${medicineItem.name} Refill', 'current supply is empty.',
          DateTime.now(), 'medicine ${medicineItem.id}', sound: 'happy_tone_short').then((value) => null);
    }
    else if(medicineItem.supplyCurrent <= medicineItem.supplyMin){
      singleNotificationCallback( 1, '${medicineItem.name} Refill', 'current supply  is running out.',
          DateTime.now(), 'medicine ${medicineItem.id}', sound: 'happy_tone_short').then((value) => null);
    }
  }
}
