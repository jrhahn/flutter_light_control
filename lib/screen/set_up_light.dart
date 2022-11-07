import 'package:flutter/material.dart';
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
  String _url = 'IP address, e.g. 192.128.0.1';
  late TextEditingController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Loading counter value on start
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _url = (prefs.getString('url') ??  'IP address, e.g. 192.128.0.1');
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _loadCounter();
  }

  Future<void> _storeUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // _url = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setString('url', _controller.text);
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
        TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: _url,
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
            ),
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
            // onSave()
            _storeUrl();
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ]),
      //
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(), body: buildBody(context));
  }
}
