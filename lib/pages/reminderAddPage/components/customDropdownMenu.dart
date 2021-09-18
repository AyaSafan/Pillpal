import 'package:flutter/material.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/theme.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({Key? key,
    this.allMedicine = const [],
    this.onSaved,
    required this.formKey,
    this.selectedMedicine,
  }) : super(key: key);

  final List<Medicine> allMedicine;
  final Medicine? selectedMedicine;
  final void Function(String?)? onSaved;
  final formKey;


  @override
  _CustomDropdownMenuState createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {

  var medTextController = TextEditingController();
  String searchString ='';
  bool dropdownShow = false;
  Medicine? selectedMedicine;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedMedicine = widget.selectedMedicine;
      searchString = widget.selectedMedicine?.name ?? '';
      medTextController.text = widget.selectedMedicine?.name ??'';
    });
  }



  @override
  Widget build(BuildContext context) {
    final curveSize = MediaQuery. of(context). size. width / 20;

    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            setState((){
              searchString = value;
            });
          },
          onTap:(){setState(() {
            dropdownShow = true;
          });
          },
          validator: (value){
            if(!widget.allMedicine.any((element) => element.name == medTextController.text)){
              return 'Please select medicine from cabinet';
            }
            return null;
          },
          onSaved: widget.onSaved ,

          controller: medTextController,
          decoration: InputDecoration(
            labelText: '${'select medicine' }',
            labelStyle: TextStyle(
                color: dropdownShow? MyColors.TealBlue : Colors.black54
            ),
            errorStyle: TextStyle(color: MyColors.MiddleRed),
            suffixIcon: IconButton(
                onPressed:(){
                  setState(() {
                    dropdownShow = !dropdownShow;
                  });
                },
                icon: Icon( Icons.arrow_drop_down_outlined,
                  color: dropdownShow? MyColors.TealBlue : Colors.grey,)
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: dropdownShow? MyColors.TealBlue : Colors.grey,),
            ),
          ),
        ),

        //This Widget is actually the dropdown List
        Visibility(
            visible: dropdownShow,
            child:
            LimitedBox(
              maxHeight: 150,
              child: Card(
                elevation: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: curveSize),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.allMedicine.length,
                      itemBuilder: (context, index) {
                        Medicine med = widget.allMedicine[index];
                        return med.name.toLowerCase().contains(searchString.toLowerCase())
                            ? TextButton.icon(
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                              padding: EdgeInsets.zero,
                              alignment:Alignment.centerLeft,
                              textStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16),
                            ),
                            icon: Icon(
                              Icons.medication,
                              color: med.pillColor,
                            ),
                            onPressed: (){
                              setState(() {
                                medTextController.text = med.name;
                                searchString = med.name;
                                selectedMedicine = med;
                                widget.formKey.currentState!.validate();
                                dropdownShow = false;
                              });
                            },
                            label: Text('${med.name}',
                            )
                        )
                            :Container();
                      }
                  ),

                ),
              ),
            )
        ),
      ],
    );
  }
}
