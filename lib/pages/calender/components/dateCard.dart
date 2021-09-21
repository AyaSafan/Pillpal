import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_pal/theme.dart';

class DateCard extends StatelessWidget {
  final DateTime? _selectedDay;
  const DateCard(this._selectedDay);

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_selectedDay!.day< 10? '0': ''}${_selectedDay!.day} ${DateFormat('MMM').format(_selectedDay!)}.',
          style: TextStyle(
              fontSize: 24,
              letterSpacing: 2,
          ),
        ),
        Text(
          '${DateFormat('EEEE').format(_selectedDay!)}'.toUpperCase(),
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

