import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_pal/theme.dart';


class DateCard extends StatelessWidget {
  //const DateCard({Key? key}) : super(key: key);
  final DateTime _focusedDay;
  const DateCard(this._focusedDay);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 150,
          ),
          child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MyColors.TealBlue,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(-2.0, 2.0), // shadow direction: bottom right
                  )
                ],
              ),

              child:Column(

                children: [
                  Container(
                      width: 120,
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 5,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 5,
                          )
                        ],
                      )

                  ),
                  Text(
                    '${_focusedDay.day< 10? '0': ''}${_focusedDay.day} ${DateFormat('MMM').format(_focusedDay)}',
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 2,
                        color: Colors.white
                    ),
                  ),
                  Text(
                    '${DateFormat('EEEE').format(_focusedDay)}'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 2,
                        color: MyColors.MiddleRed
                    ),
                  ),
                ],
              )
          ),
        ),
      ],
    );
  }
}

