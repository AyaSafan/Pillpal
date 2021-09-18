import 'dart:convert';

import 'package:floor/floor.dart';


class ListStringConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    return List.from(jsonDecode(databaseValue));
  }

  @override
  String encode(List<String> value) {
    return jsonEncode(value);
  }
}