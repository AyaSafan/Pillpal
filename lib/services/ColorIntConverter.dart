import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

class ColorIntConverter extends TypeConverter<Color, int> {
  @override
  Color decode(int databaseValue) {
    return Color(databaseValue);
  }

  @override
  int encode(Color value) {
    return value.value;
  }
}