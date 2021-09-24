import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pill_pal/components/pageFirstLayout.dart';
import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/pages/medicineAddPage/components/customUnderLineInput.dart';
import 'package:pill_pal/pages/medicineEditPage/components/PillShape.dart';
import 'package:pill_pal/theme.dart';

class MedicineAddPage extends StatefulWidget {
  const MedicineAddPage({
    Key? key,
    required this.medicineDao
  }) : super(key: key);


  final MedicineDao medicineDao;

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
  double capSize=0;
  Color pillColor = Colors.teal;
  String pillShape = 'assets/medicine.png';
  List<String> tags =[];

  final myTagController = TextEditingController();

  @override
  void dispose() {
    myTagController.dispose();
    super.dispose();
  }

  void changeColor(Color color) => setState(() => pillColor = color);
  final List<Color> pallet = [
    Colors.deepPurple, Colors.purple,  Colors.blueAccent, Colors.blue.shade200,
    Colors.teal, Colors.green, Colors.lime, Colors.yellow.shade200,
    Colors.pink.shade900, Colors.red, Colors.orange, Colors.amber,
    Colors.brown, Colors.pink.shade200, Colors.grey.shade400, Colors.white
  ];


  Future<void> insertMedicine() async{
    final med = Medicine(
      name: name,
      desc: description,
      supplyCurrent: supplyCurrent,
      supplyMin: supplyMin,
      dose: dose,
      capSize:capSize,
      pillColor: pillColor,
      pillShape: pillShape,
      tags: tags
    );
    await widget.medicineDao.insertMedicine(med);
  }

  onSubmit(){
    _formKey.currentState!.save();
    insertMedicine().then((value) => null);
    Navigator.pop(context);
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
                      child: Text("Add"),
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
              child: Text('Add Tag')
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ));


    return PageFirstLayout(
      appBarTitle: 'Add Pill',
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
            Row(
              children: [
                Flexible(
                  child: CustomUnderLineInput(
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
                ),
                SizedBox(width: 24,),
                Flexible(
                  child: CustomUnderLineInput(
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
                ),
              ],
            ),
            SizedBox(height: 24,),
            Row(
              children: [
                Flexible(child: CustomUnderLineInput(
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
                ),),
                SizedBox(width: 24,),
                Flexible(
                  child: CustomUnderLineInput(
                    labelText: 'Strength',
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
                   backgroundColor: Colors.black87,
                   title: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Select a color', style: TextStyle(color: Colors.white),),
                       IconButton(onPressed: (){
                         Navigator.pop(context);
                       },
                       icon: Icon(Icons.arrow_forward, color: Colors.white,)
                      )
                     ],
                   ),
                   content: SingleChildScrollView(
                     child: 
                     BlockPicker(
                       pickerColor: pillColor,
                       onColorChanged: changeColor,
                       availableColors: pallet,
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
            // ConstrainedBox(
            // constraints: BoxConstraints(
            // maxHeight: 100,
            // minWidth: 100
            // ),
            // child: ListView(
            // scrollDirection: Axis.horizontal,
            // children:[])),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PillShape(
                    elevation: pillShape== 'assets/capsule.png' ? 10: 0,
                    pillImage: 'assets/capsule.png',
                    pillColor: pillColor,
                    onTap: (){
                      setState(() {
                        pillShape = 'assets/capsule.png';
                      });
                }
                ),
                PillShape(
                    elevation: pillShape== 'assets/roundedpill.png' ? 10: 0,
                    pillImage: 'assets/roundedpill.png',
                    pillColor: pillColor,
                    onTap: (){
                      setState(() {
                        pillShape = 'assets/roundedpill.png';
                      });
                    }
                ),
                PillShape(
                    elevation: pillShape== 'assets/medicine.png' ? 10: 0,
                    pillImage: 'assets/medicine.png',
                    pillColor: pillColor,
                    onTap: (){
                      setState(() {
                        pillShape = 'assets/medicine.png';
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
