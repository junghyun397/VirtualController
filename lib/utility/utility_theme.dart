import 'package:flutter/material.dart';

const int _blackPrimaryValue = 0xFF121212;

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF121212),
    100: Color(0xFF121212),
    200: Color(0xFF121212),
    300: Color(0xFF121212),
    400: Color(0xFF121212),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF121212),
    700: Color(0xFF121212),
    800: Color(0xFF121212),
    900: Color(0xFF121212),
  },
);

const Color backgroundColor = Color.fromRGBO(35, 35, 35, 1);
const Color componentColor = Color.fromRGBO(124, 124, 124, 1);
const Color componentBorderColor = Colors.black54;