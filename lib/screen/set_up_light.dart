import 'package:flutter/material.dart';

import '../constants.dart';

class LightSetupScreen extends StatelessWidget {
  const LightSetupScreen({super.key});

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(appTitle),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        const Text("Add Light",
            textAlign: TextAlign.left, style: TextStyle(fontSize: 28)),
        const TextField(),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
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
