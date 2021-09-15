import 'package:flutter/material.dart';
import 'package:pill_pal/components/pageFirstLayout.dart';
import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/pages/cabinet/components/medicineCard.dart';

import 'package:pill_pal/entities/medicine.dart';


class Cabinet extends StatefulWidget {

  const Cabinet({
    Key? key,
    required this.medicineDao
  }) : super(key: key);


  final MedicineDao medicineDao;

  @override
  _CabinetState createState() => _CabinetState();
}

class _CabinetState extends State<Cabinet> {

  String searchString = "";

  //
  // late AppDatabase database;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   $FloorAppDatabase.databaseBuilder('app_database.db').build().then((database) {
  //     setState(() {
  //       this.database = database;
  //     });
  //     print('init');
  //   });
  // }

  // Stream<List<Medicine>> getAllMedicines() {
  //   final result = database.medicineDao.findAllMedicines();
  //   return result;
  // }

  @override
  Widget build(BuildContext context) {
    return PageFirstLayout(
      appBarTitle: "My Cabinet",
      topChild: Container(
        margin: EdgeInsets.fromLTRB(30,0,30,15),
        child: TextField(
          onChanged: (value) {
            setState((){
              searchString = value;
            });

          },
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
            hintText: 'Search',
            fillColor: Colors.white,
            focusColor: Theme.of(context).primaryColor,
            filled: true,
            contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),


        ),
      ),
      containerChild:  StreamBuilder<List<Medicine>> (
          stream: widget.medicineDao.findAllMedicines(),
          builder: (context, snapshot) {
            // if(snapshot.connectionState != ConnectionState.done) {
            //   print(snapshot.requireData);
            // }
            if(snapshot.hasError) {
              return Text('error');
            }
            //List<Medicine> medList = snapshot.data ?? [];
            if (!snapshot.hasData) return Container();

            final medList = snapshot.requireData;

            return ListView.builder(
                itemCount: medList.length,
                itemBuilder: (context, index) {
                  Medicine medicineItem = medList[index];
                  return medicineItem.name.toLowerCase().contains(searchString)
                      || medicineItem.tags.any(
                              (element) => element.toLowerCase().contains(searchString)
                      )? MedicineCard(medicineItem: medicineItem)
                      :Container();
                }
            );
          }
      ),
    );
  }
}
