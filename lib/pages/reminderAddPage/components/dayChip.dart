import 'package:flutter/material.dart';
import 'package:pill_pal/theme.dart';

class DayChip extends StatelessWidget {
  const DayChip({Key? key,
    this.label ='',
    this.selected = false,
    this.onSelected
  }) : super(key: key);

  final String label;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text('$label', style: TextStyle(fontFamily: 'Raleway'),),
      selected: selected,
      onSelected: onSelected,
      selectedColor: MyColors.MiddleBlueGreen,
      elevation: 4,
      showCheckmark: false,
    );
  }
}
