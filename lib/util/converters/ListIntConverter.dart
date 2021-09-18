import 'dart:convert';

import 'package:floor/floor.dart';


class ListIntConverter extends TypeConverter<List<int>, String> {
  @override
  List<int> decode(String databaseValue) {
    return List.from(jsonDecode(databaseValue));
  }

  @override
  String encode(List<int> value) {
    return jsonEncode(value);
  }
}