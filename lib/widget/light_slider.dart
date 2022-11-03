import 'package:flutter/material.dart';
import 'package:flutter_light_control/rest.dart';

class LightSlider extends StatefulWidget {
  const LightSlider({super.key});

  @override
  State<LightSlider> createState() => _LightSliderState();
}

class _LightSliderState extends State<LightSlider> {
  double _currentSliderValue = 20;

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
      onChangeEnd:  (double value) {
        setBrightness(value / 100);
        },
    );
  }
}
