import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/components/pageFirstLayout.dart';
import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/pages/medicineAddPage/components/customUnderLineInput.dart';
import 'package:pill_pal/pages/reminderAddPage/components/customDropdownMenu.dart';
import 'package:pill_pal/pages/reminderAddPage/components/dayChip.dart';
import 'package:pill_pal/theme.dart';

class ReminderAddPage extends StatefulWidget {
  const ReminderAddPage({Key? key,
      required this.reminderDao,
      required this.medicineDao
  }) : super(key: key);


final ReminderDao reminderDao;
final MedicineDao medicineDao;

  @override
  _ReminderAddPageState createState() => _ReminderAddPageState();
}

class _ReminderAddPageState extends State<ReminderAddPage> {
  final _formKey = GlobalKey<FormState>();

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  bool repeat = false;
  List<int> days = [];
  String label = '';
  List<Medicine> allMedicine = [];

  Medicine? savedSelectedMedicine;

  // var medTextController = TextEditingController();
  // String searchString ='';
  // Medicine? selectedMedicine;
  // bool dropdownShow = true;

    Future<List<Medicine>> getAllMedicine() async {
      final medicines = await widget.medicineDao.findAllMedicines();
      return medicines;
    }

    @override
    void initState() {
      super.initState();
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
        SnackBar(content: Text('Adding to Cabinet ...')),
      );
      Navigator.pop(context);
    }


    @override
    Widget build(BuildContext context) {
      // final curveSize = MediaQuery. of(context). size. width / 20;

      return PageFirstLayout(
        appBarTitle: 'Add Reminder',
        color: MyColors.Landing1,
        showFAB: false,
        containerChild:
        ListView(
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
                      SizedBox(width: 8,),
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
                      SizedBox(width: 8,),
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
                      SizedBox(width: 8,),
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
                      SizedBox(width: 8,),
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
                      SizedBox(width: 8,),
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
                      SizedBox(width: 8,),
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
                    onSaved:(value){
                      allMedicine.forEach((element){
                        if(element.name == value){
                          setState(() {
                            savedSelectedMedicine = element;
                          });
                        }
                      });
                      print(savedSelectedMedicine?.name);
                    },
                  ),

                  // TextFormField(
                  //   onChanged: (value) {
                  //     setState((){
                  //       searchString = value;
                  //     });
                  //   },
                  //   validator: (value){
                  //     if(!allMedicine.any((element) => element.name == medTextController.text)){
                  //       return 'Please select medicine from cabinet';
                  //       }
                  //       return null;
                  //   },
                  //
                  //   controller: medTextController,
                  //   decoration: InputDecoration(
                  //     labelText: '${'select medicine' }',
                  //     labelStyle: TextStyle(
                  //         color: dropdownShow? MyColors.TealBlue : Colors.black54
                  //     ),
                  //     errorStyle: TextStyle(color: MyColors.MiddleRed),
                  //     suffixIcon: IconButton(
                  //       onPressed:(){
                  //         setState(() {
                  //           dropdownShow = !dropdownShow;
                  //         });
                  //       },
                  //       icon: Icon( Icons.arrow_drop_down_outlined,
                  //       color: dropdownShow? MyColors.TealBlue : Colors.grey,)
                  //       ),
                  //     disabledBorder: UnderlineInputBorder(
                  //       borderSide: BorderSide(color: dropdownShow? MyColors.TealBlue : Colors.grey,),
                  //     ),
                  //   ),
                  // ),
                  //
                  // //This Widget is actually the dropdown List
                  // Visibility(
                  //   visible: dropdownShow,
                  //     child:
                  //     LimitedBox(
                  //       maxHeight: 150,
                  //       child: Card(
                  //         elevation: 8,
                  //         child: Container(
                  //           padding: EdgeInsets.symmetric(horizontal: curveSize),
                  //           child: ListView.builder(
                  //               shrinkWrap: true,
                  //               itemCount: allMedicine.length,
                  //               itemBuilder: (context, index) {
                  //                 Medicine med = allMedicine[index];
                  //                 return med.name.toLowerCase().contains(searchString.toLowerCase())
                  //                     ? TextButton.icon(
                  //                     style: TextButton.styleFrom(
                  //                       primary: Colors.black,
                  //                       padding: EdgeInsets.zero,
                  //                       alignment:Alignment.centerLeft,
                  //                       textStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16),
                  //                     ),
                  //                     icon: Icon(
                  //                       Icons.medication,
                  //                       color: med.pillColor,
                  //                     ),
                  //                     onPressed: (){
                  //                       setState(() {
                  //                         medTextController.text = med.name;
                  //                         searchString = med.name;
                  //                         selectedMedicine = med;
                  //                         dropdownShow = false;
                  //                         _formKey.currentState!.validate();
                  //                       });
                  //                     },
                  //                     label: Text('${med.name}',
                  //                     )
                  //                 )
                  //                     :Container();
                  //               }
                  //           ),
                  //
                  //         ),
                  //       ),
                  //     )
                  // ),

                  SizedBox(height: 32,),
                  Center(
                    child:
                    ElevatedButton.icon(
                      style: ButtonStyle(
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
