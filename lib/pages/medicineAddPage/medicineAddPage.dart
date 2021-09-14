import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:pill_pal/components/pageFirstLayout.dart';
import 'package:pill_pal/pages/medicineAddPage/components/customUnderLineInput.dart';

import 'package:pill_pal/database.dart';
import 'package:pill_pal/entities/medicine.dart';


class MedicineAddPage extends StatefulWidget {
  const MedicineAddPage({Key? key}) : super(key: key);

  @override
  _MedicineAddPageState createState() => _MedicineAddPageState();
}

class _MedicineAddPageState extends State<MedicineAddPage> {
  final _formKey = GlobalKey<FormState>();

  String name ='';
  String description ='';
  double supplyCurrent =0;
  double supplyMin=0;
  double dose=1;
  double doseFrequency=1;
  double capSize=0;
  Color pillColor = Color(0xFFCCCCCC);
  List<String> tags =[];

  final myTagController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myTagController.dispose();
    super.dispose();
  }

  void changeColor(Color color) => setState(() => pillColor = color);

  Future<void> insertMedicine() async{
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final medicineDao = database.medicineDao;
    final med = Medicine(
      name: name,
      desc: description,
      supplyCurrent: supplyCurrent,
      supplyMin: supplyMin,
      dose: dose,
      doseFrequency: doseFrequency,
      capSize:capSize,
      pillColor: pillColor,
      tags: tags
    );
    await medicineDao.insertMedicine(med);
  }

  onSubmit(){
    _formKey.currentState!.save();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Adding to Cabinet' )),
    );
    insertMedicine().then((value) => null);
  }


  @override
  Widget build(BuildContext context) {

    List<Widget> chips = tags.map((tag) =>
        Chip(
          label: Text('$tag'),
          backgroundColor: Color(0xFFEEEEEE),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onDeleted: (){setState(() {
            tags.remove(tag);
          });},
        )
    ).toList();

    chips.add(
        Chip(
          onDeleted:(){},
          deleteIcon: Icon(
              Icons.sell,
          ),
          backgroundColor: MyColors.Landing2,
          label: 
          GestureDetector(
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    //title: Text('Select a color'),
                    content: SingleChildScrollView(
                      child: TextFormField(
                        controller: myTagController,
                        autovalidateMode:AutovalidateMode.onUserInteraction,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          labelText: 'Tag',
                          labelStyle: TextStyle(
                              color: Colors.black54
                          ),
                          focusColor: Theme.of(context).primaryColor,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide( color: Colors.grey,),
                          ),
                          focusedBorder:  UnderlineInputBorder(
                            borderSide:  BorderSide( color: Theme.of(context).primaryColor),
                          ),

                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter tag text';
                          }
                          return null;
                        },
                      ),
                    ),
                    actions: [
                    TextButton(
                      child: Text("ADD"),
                      onPressed: () { 
                        setState(() {
                          tags.add(myTagController.text);
                          Navigator.pop(context);
                        });
                      },
                      )
                    ],
                  );
                },
              );
            },
              child: Text('Add Tag', style: TextStyle(fontSize: 16))
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ));


    return PageFirstLayout(
      appBarTitle: 'Add Medicine',
      //appBarRight: Image.asset('assets/pillpal.png', height: 80, width: 66) ,
      color: MyColors.Landing2,
      showFAB: false,
      containerChild: ListView(
        children: [
        Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomUnderLineInput(
              labelText: 'Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter medicine name';
                }
                return null;
              },
              onSaved: (value){setState(() {
                name = value ?? '';
              });},
            ),
            SizedBox(height: 24,),
            CustomUnderLineInput(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              labelText: 'Description',
              onSaved: (value){setState(() {
                description = value ?? '';
              });},
            ),
            SizedBox(height: 24,),
            CustomUnderLineInput(
              labelText: 'Current Supply',
              suffixText: 'pills',
              initialValue: '0',
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse('$value').runtimeType != double) {
                  return 'Please enter a number';
                }
                return null;
              },
              onSaved: (value){setState(() {
                supplyCurrent = double.tryParse('$value')?? 0;
              });},
            ),
            SizedBox(height: 24,),
            CustomUnderLineInput(
              labelText: 'Minimum Supply',
              suffixText: 'pills',
              initialValue: '0',
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse('$value').runtimeType != double ) {
                  return 'Please enter a number';
                }
                return null;
              },
              onSaved: (value){setState(() {
                supplyMin = double.tryParse('$value')?? 0;
              });},
            ),
            SizedBox(height: 24,),
            CustomUnderLineInput(
              labelText: 'Dose',
              suffixText: 'pill/dose',
              initialValue: '1',
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse('$value').runtimeType != double ) {
                  return 'Please enter a number';
                }
                return null;
              },
              onSaved: (value){setState(() {
                dose = double.tryParse('$value') ?? 0;
              });},
            ),
            SizedBox(height: 24,),
            CustomUnderLineInput(
              labelText: 'Daily Amount',
              suffixText: 'dose/day',
              initialValue: '1',
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse('$value').runtimeType != double ) {
                  return 'Please enter a number';
                }
                return null;
              },
              onSaved: (value){setState(() {
                doseFrequency = double.tryParse('$value') ?? 0;
              });},
            ),
            SizedBox(height: 24,),
            CustomUnderLineInput(
              labelText: 'Cap Size',
              suffixText: 'mg',
              initialValue: '0',
              validator: (value) {
              if (!(value == null || value.isEmpty)) {
                if (double
                    .tryParse('$value')
                    .runtimeType != double) {
                  return 'Please enter a number';
                }
              }
                return null;
              },
              onSaved: (value){setState(() {
                capSize = double.tryParse('$value')?? 0;
              });},
            ),
            SizedBox(height: 24,),
            GestureDetector(
             onTap:(){
               showDialog(
                   context: context,
                   builder: (BuildContext context) {
                 return AlertDialog(
                   title: Text('Select a color'),
                   content: SingleChildScrollView(
                     child: BlockPicker(
                       pickerColor: pillColor,
                       onColorChanged: changeColor,
                     ),
                   ),
                 );
               },
               );
             },
             child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Pill Color',
                labelStyle: TextStyle(
                    color: Colors.black54
                ),
                suffixIcon:
                Card(
                  elevation: 4,
                  shape: CircleBorder(),
                  color: pillColor,
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide( color: Colors.grey,),
                ),

              ),
              // The validator receives the text that the user has entered.
          ),
           ),
            SizedBox(height: 24,),
            //Text("Tags",style: TextStyle(fontSize: 16, color: Colors.black54)),
            Wrap(
              runSpacing: 2,
              spacing: 5,
              children: chips,
            ),
            SizedBox(height: 32,),
            Center(
              child:
              ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text('Add to Cabinet', style: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.white),),
                ),
              ),
            ),


          ],
        ),
      )

        ],
      ),
    );
  }
}
