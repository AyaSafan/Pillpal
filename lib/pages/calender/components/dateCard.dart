import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_pal/theme.dart';

class DateCard extends StatelessWidget {
  final DateTime _focusedDay;
  const DateCard(this._focusedDay);

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_focusedDay.day< 10? '0': ''}${_focusedDay.day} ${DateFormat('MMM').format(_focusedDay)}.',
          style: TextStyle(
              fontSize: 24,
              letterSpacing: 2,
          ),
        ),
        Text(
          '${DateFormat('EEEE').format(_focusedDay)}'.toUpperCase(),
          style: TextStyle(
              fontSize: 20,
              letterSpacing: 2,
              color: MyColors.TealBlue,
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}

