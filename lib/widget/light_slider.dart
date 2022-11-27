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

void _showToast(BuildContext context, String ipAddress) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text('Light control server not reachable (http://$ipAddress)'),
      action:
          SnackBarAction(label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

class _LightSliderState extends State<LightSlider> {
  double _currentSliderValue = 20;
  String ipAddress = "";

  final int scaler = 100;

  _LightSliderState({required this.ipAddress});

  @override
  void initState() {
    super.initState();

    getCurrentBrightnessFromDevice();
  }

  void sendRequest(double value) async {
    final bool success = await setBrightness(value / scaler, ipAddress);

    if (!success) {
      logger.e("Error setting brightness for $ipAddress");

      _showToast(context, ipAddress);
    }
  }

  void getCurrentBrightnessFromDevice() async {
    final double brightness = await getBrightness(ipAddress);
    print("received: ${brightness}  ");

    setState(() {
      _currentSliderValue = scaler.toDouble() * brightness;
    });
  }

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
        sendRequest(value);
      },
    );
  }
}
