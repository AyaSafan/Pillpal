import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
import 'package:pill_pal/components/pageSecondLayout.dart';
import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/pages/medicineItemPage/components/CustomCard.dart';

class MedicineItemPage extends StatefulWidget {
  const MedicineItemPage({Key? key,
    required this.medicineDao,
    required this.med
  }) : super(key: key);


  final MedicineDao medicineDao;
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
    return PageSecondLayout(
      appBarTitle: medicineItem.name ,
      appBarRight: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: (){
          showModalBottomSheet<void>(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MediaQuery. of(context). size. width / 20),
            ),
            builder: (BuildContext context) {
              return Container(
                height: 240,
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
                            textStyle: Theme.of(context).textTheme.bodyText2,
                          ),
                          label: Text('Take Dose'),
                          icon: Icon(
                            Icons.timelapse,
                          ),
                          onPressed: () {
                            if(medicineItem.supplyCurrent >= medicineItem.dose) {
                              //widget.medicineDao.takeDose(medicineItem.id ?? 0).then((value) => print('taken'));
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
                                SnackBar(content: Text('Current Supply Empty' )),
                              );
                            }
                          },
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            textStyle: Theme.of(context).textTheme.bodyText2,
                          ),
                          label: Text('Add Reminder'),
                          icon: Icon(
                            Icons.notification_add,
                          ),
                          onPressed: () {
                          },
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            textStyle: Theme.of(context).textTheme.bodyText2,
                          ),
                          label: Text('Edit Medicine'),
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
                            textStyle: Theme.of(context).textTheme.bodyText2,
                          ),
                          label: Text('Delete Medicine'),
                          icon: Icon(
                            Icons.delete,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child:
                                    Column(
                                      children: [
                                        Text('${medicineItem.name} will be permanently deleted.',
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ],
                                    )
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text("Delete"),
                                      onPressed: () {
                                        widget.medicineDao.deleteMedicine(medicineItem).then((value) => null);
                                        Navigator.popUntil(context, ModalRoute.withName('/cabinet') );
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

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
      ),
      showFAB: false,
      topChild:  Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                medicineItem.desc.isNotEmpty ? Column(
                  children: [
                    Text(
                      medicineItem.desc,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Raleway',
                      ),
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
                SizedBox(height: 16,),

              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Image.asset('assets/pill.png', height: 60, width: 80)],
          ),
        ],
      ),
      containerChild: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              CustomCard(
                title: 'Current Supply',
                data: '${medicineItem.supplyCurrent} pills',
                icon: Icon(
                  Icons.assignment_turned_in,
                  color: MyColors.TealBlue,
                ),
                color: MyColors.TealBlue,
              ),
              CustomCard(
                title: 'Minimun Supply',
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
                  color: Colors.purple,
                ),
                color: Colors.purple,
              ),
              CustomCard(
                title: 'Daily Amount',
                data: '${medicineItem.doseFrequency} dose/day',
                icon: Icon(
                  Icons.access_time_filled,
                  color: MyColors.MiddleBlueGreen,
                ),
                color: MyColors.MiddleBlueGreen,
              ),
            ],
          ),
          Row(children: [
            CustomCard(
              title: 'Cap Size',
              data: '${medicineItem.capSize} mg',
              icon: Icon(
                Icons.hourglass_bottom,
                color: MyColors.MiddleRed,
              ),
              color: MyColors.MiddleRed,
            ),
            CustomCard(
              title: 'Shape',
              data: '${medicineItem.pillShape}',
              icon: Icon(
                Icons.hourglass_bottom,
                color: MyColors.Aero,
              ),
              color: MyColors.Aero,
            ),
          ],)
        ],
      )
    );
  }
}
