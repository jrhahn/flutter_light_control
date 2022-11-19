import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_light_control/light_configuration.dart';
import 'package:flutter_light_control/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../constants.dart';

var logger = Logger();

String getRandomString(int length) {
  const characters =
      '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}

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

  late LightConfiguration config;
  String id = getRandomString(32);

  InputData(LightConfiguration config) {
    this.config = config;

    this.controllerName = TextEditingController();
    this.controllerIpAddress = TextEditingController();

    this.controllerName.text = config.name;
    this.controllerIpAddress.text = config.ipAddress;
  }
}

class LightSetupScreen extends StatefulWidget {
  const LightSetupScreen({super.key});

  @override
  State<LightSetupScreen> createState() => _LightSetupScreenState();
}

class _LightSetupScreenState extends State<LightSetupScreen> {
  Map<String, InputData> configs = {};

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

    _loadLightConfigs();
  }

  void _createNewLightConfig() {
    final lightConfiguration = LightConfiguration(
        'IP address, e.g. 192.128.0.1', 'Name, e.g. "Kitchen Light"');

    final emptyEntry = InputData(lightConfiguration);

    configs[emptyEntry.id] = emptyEntry;
  }

  // Loading counter value on start
  Future<void> _loadLightConfigs() async {
    final lightConfigs = await loadLightConfigurations();

    lightConfigs.forEach((id, config) {
      setState(() {
        final inputData = InputData(config);
        configs[inputData.id] = inputData;
      });
    });
  }
  // final prefs = await SharedPreferences.getInstance();
  // final serializedConfigs = prefs.getString('lightConfiguration') ?? "{}";

  // logger.d("Read $serializedConfigs");

  // try {
  //   final listConfigs = jsonDecode(serializedConfigs);
  //   logger.d(listConfigs);

  //   listConfigs.forEach((id, config) {
  //     final data = InputData(LightConfiguration.fromJson(config));

  //     setState(() {
  //       configs[data.id] = data;
  //     });
  //   });
  // } on FormatException catch (e) {
  //   logger.e("$e (json: $serializedConfigs)");
  // }
  // }

  Future<void> _storeLightConfiguration() async {
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

  Widget createLightConfigWidget(
    InputData data,
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
        widgets.add(createLightConfigWidget(config));
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
                _createNewLightConfig();
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
    return Scaffold(
      appBar: AppBar(title: const Text("Edit your light settings")),
      body: buildBody(context),
    );
  }
}
