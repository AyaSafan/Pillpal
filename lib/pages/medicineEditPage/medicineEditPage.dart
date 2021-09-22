import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pill_pal/components/pageFirstLayout.dart';
import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/my_flutter_app_icons.dart';
import 'package:pill_pal/pages/medicineAddPage/components/customUnderLineInput.dart';
import 'package:pill_pal/pages/medicineEditPage/components/PillShape.dart';
import 'package:pill_pal/theme.dart';

class MedicineEditPage extends StatefulWidget {
  const MedicineEditPage({
    Key? key,
    required this.medicineDao,
    required this.med
  }) : super(key: key);


  final MedicineDao medicineDao;
  final Medicine med;

  @override
  _MedicineAddPageState createState() => _MedicineAddPageState();
}

class _MedicineAddPageState extends State<MedicineEditPage> {
  final _formKey = GlobalKey<FormState>();

  Medicine editedMedicine = Medicine(name: '');
  int? id;
  String name ='';
  String description ='';
  double supplyCurrent =0;
  double supplyMin=0;
  double dose=1;
  double capSize=0;
  Color pillColor = Color(0xff000000);
  int pillShapeNum =2;
  List<String> tags =[];

  @override
  void initState() {
    super.initState();
    setState(() {
      editedMedicine = widget.med;
      id = widget.med.id;
      name = widget.med.name;
      description = widget.med.desc;
      supplyCurrent = widget.med.supplyCurrent;
      supplyMin = widget.med.supplyMin;
      dose = widget.med.dose;
      capSize = widget.med.capSize;
      pillColor = widget.med.pillColor;
      pillShapeNum= widget.med.pillShapeNum;
      tags= widget.med.tags;
    });
  }

  final myTagController = TextEditingController();

  @override
  void dispose() {
    myTagController.dispose();
    super.dispose();
  }

  void changeColor(Color color) => setState(() => pillColor = color);

  Future<void> updateMedicine() async{
    await widget.medicineDao.updateMedicine(editedMedicine);
  }

  onSubmit(){
    _formKey.currentState!.save();
    setState(() {
      editedMedicine = Medicine(
          id: id,
          name: name,
          desc: description,
          supplyCurrent: supplyCurrent,
          supplyMin: supplyMin,
          dose: dose,
          capSize:capSize,
          pillColor: pillColor,
          pillShapeNum: pillShapeNum,
          tags: tags
      );
    });
    updateMedicine().then((value) => null);
    Navigator.pushNamedAndRemoveUntil(context, '/medicine_item',  ModalRoute.withName('/cabinet'), arguments: editedMedicine,);
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
      appBarTitle: name,
      color: MyColors.Landing2,
      appBarRight: IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              onSubmit();
            }
          }
      ),
      containerChild: ListView(
        children: [
        Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomUnderLineInput(
              labelText: 'Name',
              initialValue: "$name",
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
              initialValue: "$description",
              onSaved: (value){setState(() {
                description = value ?? '';
              });},
            ),
            SizedBox(height: 24,),
            Row(
              children: [
                Flexible(
                  child:CustomUnderLineInput(
                    labelText: 'Current Supply',
                    suffixText: 'pills',
                    initialValue: "$supplyCurrent",
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
                ),
                SizedBox(width: 24,),
                Flexible(
                  child: CustomUnderLineInput(
                    labelText: 'Minimum Supply',
                    suffixText: 'pills',
                    initialValue: "$supplyMin",
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
                ),
              ],
            ),
            SizedBox(height: 24,),
            Row(
              children: [
                Flexible(child: CustomUnderLineInput(
                  labelText: 'Dose',
                  suffixText: 'pill/dose',
                  initialValue: "$dose",
                  validator: (value) {
                    if (value == null || value.isEmpty || double.tryParse('$value').runtimeType != double ) {
                      return 'Please enter a number';
                    }
                    return null;
                  },
                  onSaved: (value){setState(() {
                    dose = double.tryParse('$value') ?? 0;
                  });},
                ),),
                SizedBox(width: 24,),
                Flexible(
                  child: CustomUnderLineInput(
                    labelText: 'Cap Size',
                    suffixText: 'mg',
                    initialValue: "$capSize",
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
                ),
              ],
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
                     child:
                     BlockPicker(
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
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide( color: Colors.grey,),
                ),

              ),
          ),
           ),
            SizedBox(height: 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PillShape(
                    elevation: pillShapeNum==0 ? 10: 0,
                    icon: Icon( MyFlutterApp.capsule,
                      color: pillColor,
                      size: 60,),
                    pillColor: pillColor,
                    onTap: (){
                      setState(() {
                        pillShapeNum = 0;
                      });
                    }
                ),
                PillShape(
                    elevation: pillShapeNum==1 ? 10: 0,
                    icon: Icon( MyFlutterApp.roundpill,
                      color: pillColor,
                      size: 60,),
                    pillColor: pillColor,
                    onTap: (){
                      setState(() {
                        pillShapeNum = 1;
                      });
                    }
                ),
                PillShape(
                    elevation: pillShapeNum==2 ? 10: 0,
                    icon: Icon( Icons.medication,
                      color: pillColor,
                      size: 60,),
                    pillColor: pillColor,
                    onTap: (){
                      setState(() {
                        pillShapeNum = 2;
                      });
                    }
                ),
              ],
            ),
            SizedBox(height: 24,),
            Wrap(
              runSpacing: 2,
              spacing: 5,
              children: chips,
            ),
            SizedBox(height: 32,),
          ],
        ),
      )

        ],
      ),
    );
  }
}


