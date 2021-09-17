import 'package:flutter/material.dart';
import 'package:pill_pal/components/pageFirstLayout.dart';
import 'package:pill_pal/theme.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return PageFirstLayout(
      appBarTitle: 'PillPal',
      appBarRight:Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image.asset('assets/pill.png', height: 60, width: 80),
      ) ,
      containerChild:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  label: Text('My Calender'),
                  icon: Icon(
                    Icons.event_outlined,
                    color: MyColors.MiddleRed,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/calender');
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  label: Text('My Cabinet'),
                  icon: Icon(Icons.medical_services_outlined,
                      color: MyColors.TealBlue, size: 30),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cabinet');
                  },
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 2,
                  height: 32,
                ),

              ],
            ),
    );
  }
}
