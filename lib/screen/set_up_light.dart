import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_light_control/light_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

// Define a custom Form widget.
// class MyCustomForm extends StatefulWidget {
//   const MyCustomForm({super.key});
//
//   @override
//   State<MyCustomForm> createState() => _MyCustomFormState();
// }

//
// // Define a corresponding State class.
// // This class holds the data related to the Form.
// class _MyCustomFormState extends State<MyCustomForm> {
//   // Create a text controller and use it to retrieve the current value
//   // of the TextField.
//   final myController = TextEditingController();
//
//   int _counter = 0;
//
//   //Loading counter value on start
//   Future<void> _loadCounter() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _counter = (prefs.getInt('counter') ?? 0);
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCounter();
//   }

//   Future<void> _incrementCounter() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _counter = (prefs.getInt('counter') ?? 0) + 1;
//       prefs.setInt('counter', _counter);
//     });
//   }
//
//   @override
//   void dispose() {
//     // Clean up the controller when the widget is disposed.
//     myController.dispose();
//     super.dispose();
//   }
//

//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: TextField(
//           controller: myController,
//         ),
//       );
//   }
// }

class InputData {
  late TextEditingController controllerName;
  late TextEditingController controllerIpAddress;

  LightConfiguration config;

  InputData(this.config); //, this.controllerName, this.controllerIpAddress);

}

Widget createLightConfigWidget(InputData data) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
            child: TextField(
                controller: data.controllerName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: data.config.name,
                ))),
        Container(width: 10),
        Flexible(
            child: TextField(
                controller: data.controllerIpAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: data.config.ipAddress,
                ))),
      ]));
}

class LightSetupScreen extends StatefulWidget {
  const LightSetupScreen({super.key});

  @override
  State<LightSetupScreen> createState() => _LightSetupScreenState();
}

class _LightSetupScreenState extends State<LightSetupScreen> {
  final _lightConfiguration = LightConfiguration(
      'IP address, e.g. 192.128.0.1', 'Name, e.g. "Kitchen Light"');

  var numNewConfigs = 5;

  List<InputData> configs = [];

  @override
  void dispose() {
    void _dispose(InputData config) {
      config.controllerName.dispose();
      config.controllerIpAddress.dispose();
    }

    configs.forEach(_dispose);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _prepareWidgets();
  }

  void _prepareWidgets() {
    final numExistingConfigs = 1;
    final numTotalConfigs = numExistingConfigs + numNewConfigs;

    configs.clear();

    for (var ii = 0; ii < numTotalConfigs; ii++) {
      configs.add(InputData(_lightConfiguration));
    }

    void initLightConfig(InputData config) {
      config.controllerName = TextEditingController();
      config.controllerIpAddress = TextEditingController();
    }

    configs.forEach(initLightConfig);

    _loadLightConfigs();
  }

  // Loading counter value on start
  Future<void> _loadLightConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final numLights = prefs.getInt('numLights') ?? 0;

    for (var ii = 0; ii < numLights; ii++) {
      final lightConfigurationJson = prefs.getString('lightConfiguration');
      if (lightConfigurationJson != null) {
        setState(() {
          configs.add(InputData(
              LightConfiguration.fromJson(jsonDecode(lightConfigurationJson))));
        });
      }
    }
  }

  Future<void> _storeLightConfiguration() async {
    final prefs = await SharedPreferences.getInstance();

    void storeConfig(InputData data) {
      final config = LightConfiguration(
        data.controllerIpAddress.text,
        data.controllerName.text,
      );
      prefs.setString('lightConfiguration', jsonEncode(config));
    }

    prefs.setInt('numLights', configs.length);
    configs.forEach(storeConfig);
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(appTitle),
    );
  }

  void _addLightConfiguration() {
    setState(() {
      numNewConfigs++;
      _prepareWidgets();
    });
  }

  List<Widget> buildLightConfigWidgets(BuildContext context) {
    List<Widget> buildWidgets() {
      List<Widget> widgets = [];

      for (var ii = 0; ii < configs.length; ii++) {
        widgets.add(createLightConfigWidget(configs[ii]));
      }
      return widgets;
    }

    List<Widget> widgets = [];

    widgets.add(SingleChildScrollView(
      child: Column(children: buildWidgets()),
    ));

    widgets.add(Container(
      height: 10,
    ));

    widgets.add(SizedBox(
        width: 50,
        height: 50,
        child: ElevatedButton(
            onPressed: () {
              _addLightConfiguration();
            },
            child: const Text('+', style: TextStyle(fontSize: 20)),
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ))))));

    widgets.add(Container(
      height: 10,
    ));

    widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  _storeLightConfiguration();
                  Navigator.pop(context);
                },
                child: const Text('Save', style: TextStyle(fontSize: 20))))));

    return widgets;
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: buildLightConfigWidgets(context)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(), body: buildBody(context));
  }
}
