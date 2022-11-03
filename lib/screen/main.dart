import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_light_control/rest.dart';

import '../widget/light_slider.dart';


Widget mainScreen() {
  return Padding(
    padding: EdgeInsets.all(15.0),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget> [
          Text("Light 1",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 28)),
          LightSlider()
        ]),);
}