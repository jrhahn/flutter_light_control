import 'package:flutter/material.dart';
import 'package:flutter_light_control/rest.dart';

import 'package:logger/logger.dart';

var logger = Logger();

class LightSlider extends StatefulWidget {
  final String ipAddress;
  const LightSlider({super.key, required this.ipAddress});

  @override
  State<LightSlider> createState() => _LightSliderState(ipAddress: ipAddress);
}

void errorDialog(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('AlertDialog Title'),
      content: const Text('AlertDialog description'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

class _LightSliderState extends State<LightSlider> {
  double _currentSliderValue = 20;
  String ipAddress = "";

  _LightSliderState({required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      min: 0,
      max: 100,
      divisions: 100,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
      onChangeEnd: (double value) {
        try {
          setBrightness(value / 100, ipAddress);
        } catch (e) {
          logger.e("Error setting brightness for $ipAddress: $e");

          errorDialog(context);
        }
      },
    );
  }
}
