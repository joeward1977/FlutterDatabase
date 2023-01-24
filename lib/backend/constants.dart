import 'package:flutter/material.dart';

const headerColor = Color.fromARGB(255, 11, 111, 44);
const backgroundColor = Color.fromARGB(255, 228, 229, 255);
const buttonColor = Color.fromARGB(255, 70, 76, 248);

var buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: buttonColor, // Background color
);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);
