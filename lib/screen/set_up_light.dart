import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_light_control/light_configuration.dart';
import 'package:flutter_light_control/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:flutter_light_control/light_configuration_controller.dart';

var logger = Logger();

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

class LightSetupScreen extends StatefulWidget {
  const LightSetupScreen({super.key});

  @override
  State<LightSetupScreen> createState() => _LightSetupScreenState();
}

class _LightSetupScreenState extends State<LightSetupScreen> {
  Map<String, LightConfigurationController> configs = {};

  @override
  void dispose() {
    configs.forEach((id, config) {
      config.controllerName.dispose();
      config.controllerIpAddress.dispose();
    });

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    configs.clear();

    _loadLightConfigurations();
  }

  void _addNewLightConfigurationController() {
    final lightConfiguration = LightConfiguration(
        'IP address, e.g. 192.168.178.34', 'Name, e.g. "Kitchen Light"');

    final emptyEntry = LightConfigurationController(lightConfiguration);

    configs[emptyEntry.id] = emptyEntry;
  }

  // Loading counter value on start
  Future<void> _loadLightConfigurations() async {
    final lightConfigs = await loadLightConfigurations();

    lightConfigs.forEach((id, config) {
      setState(() {
        final inputData = LightConfigurationController(config);
        configs[inputData.id] = inputData;
      });
    });
  }

  Future<void> _saveLightConfiguration() async {
    final prefs = await SharedPreferences.getInstance();

    final listConfigs = configs.map((id, config) {
      return MapEntry(
          id,
          LightConfiguration(
            config.controllerIpAddress.text,
            config.controllerName.text,
          ));
    });

    logger.d("Saving: $listConfigs");
    final serializedConfig = jsonEncode(listConfigs);
    prefs.setString('lightConfiguration', serializedConfig);
  }

  Widget createLightConfigurationWidget(
    LightConfigurationController data,
  ) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
          SizedBox(
              width: 50,
              height: 50,
              child: IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete config',
                onPressed: () {
                  setState(() {
                    configs.remove(data.id);
                  });
                },
              )),
        ]));
  }

  List<Widget> buildLightConfigWidgets(BuildContext context) {
    List<Widget> buildWidgets() {
      List<Widget> widgets = [];

      configs.forEach((id, config) {
        widgets.add(createLightConfigurationWidget(config));
      });

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
              setState(() {
                _addNewLightConfigurationController();
              });
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
                  _saveLightConfiguration();
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
    return Scaffold(
      appBar: AppBar(title: const Text("Edit your light settings")),
      body: buildBody(context),
    );
  }
}
