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

class LightSetupScreen extends StatefulWidget {
  const LightSetupScreen({super.key});

  @override
  State<LightSetupScreen> createState() => _LightSetupScreenState();
}

class _LightSetupScreenState extends State<LightSetupScreen> {
  LightConfiguration _lightConfiguration = LightConfiguration(
      'IP address, e.g. 192.128.0.1',
      'Name, e.g. "Kitchen Light"'
  );

  late TextEditingController _controllerName;
  late TextEditingController _controllerIpAddress;

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerIpAddress.dispose();
    super.dispose();
  }

  // Loading counter value on start
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();

    final lightConfigurationJson = prefs.getString('lightConfiguration');

    if (lightConfigurationJson != null) {
      setState(() {
        _lightConfiguration = LightConfiguration.fromJson(
            jsonDecode(lightConfigurationJson)
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _controllerName = TextEditingController();
    _controllerIpAddress = TextEditingController();
    _loadCounter();
  }

  Future<void> _storeLightConfiguration() async {
    final prefs = await SharedPreferences.getInstance();

    final thisConfig = LightConfiguration(
        _controllerIpAddress.text,
        _controllerName.text
    );

    setState(() {
      prefs.setString('lightConfiguration', jsonEncode(thisConfig));
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(appTitle),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child:
        TextField(
        controller: _controllerName,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: _lightConfiguration.name,
            )
        )),
          Flexible(
              child:TextField(
            controller: _controllerIpAddress,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: _lightConfiguration.ipAddress,
            )
        )),
        ]
    ),
    // onSubmitted: (String value) async {
    //   await showDialog<void>(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: const Text('Thanks!'),
    //           content: Text(
    //               'You typed "$value", which has length ${value.characters.length}.'),
    //           actions: <Widget>[
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.pop(context);
    //               },
    //               child: const Text('OK'),
    //             ),
    //           ],
    //         );
    //       });
    // }
    // ),
    // MyCustomForm(),
    // Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     const Text("Add Light",
    //         textAlign: TextAlign.left, style: TextStyle(fontSize: 28)),
    //     const TextField(),
    //   ],
    // ),
    ElevatedButton(
    onPressed: () {
    _storeLightConfiguration();
    Navigator.pop(context);
    },
    child: const Text('Save'),
    )
    ,
    ]
    )
    ,
    //
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(), body: buildBody(context));
  }
}
