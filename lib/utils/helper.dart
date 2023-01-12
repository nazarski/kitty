import 'package:flutter/material.dart';

Color fromHex(String str){
  return Color(int.parse('FF$str', radix: 16));
}