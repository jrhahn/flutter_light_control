import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_light_control/rest.dart';
import 'screen/main.dart';


// This is the type used by the popup menu below.
enum Menu { itemOne, itemTwo, itemThree, itemFour }

const String appTitle = "Light Control";

void main() {
  runApp(const LightControlApp());
}

class LightControlApp extends StatefulWidget {
  const LightControlApp({super.key});

  @override
  State<LightControlApp> createState() {
    return _LightControlAppState();
  }
}

class _LightControlAppState extends State<LightControlApp> {
  // final TextEditingController _controller = TextEditingController();
  // final TextEditingController _controller2 = TextEditingController();
  // Future<String>? _futureString;

  String _selectedMenu = '';

  AppBar buildAppBar () {
    return AppBar(
      title: const Text(appTitle),
      actions: <Widget>[
// This button presents popup menu items.
        PopupMenuButton<Menu>(
// Callback that sets the selected popup menu item.
            onSelected: (Menu item) {
              setState(() {
                _selectedMenu = item.name;
              });
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<Menu>>[
              const PopupMenuItem<Menu>(
                value: Menu.itemOne,
                child: Text('Settings'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemTwo,
                child: Text('Item 2'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemThree,
                child: Text('Item 3'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemFour,
                child: Text('Item 4'),
              ),
            ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: buildAppBar(),
        body: mainScreen()

            ),

    );


  }

  // Center buildStartScreen() {
  //   return Center(
  //         child: ListView(
  //           // alignment: Alignment.center,
  //           padding: const EdgeInsets.all(8.0),
  //           children:      <Widget>[
  //     // mainAxisAlignment: MainAxisAlignment.center,
  //     // children: <Widget>[
  //     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //       Flexible(
  //           child: TextField(
  //         controller: _controller,
  //         decoration:
  //             const InputDecoration(hintText: 'Enter a brightness value between 0 and 1.0'),
  //       )),
  //       ElevatedButton(
  //         // onPressed: !buttonEnabled ? null : () {
  //         //   buttonEnabled = false;
  //         //   setState(() {
  //         //     dis
  //             _futureString = setBrightness(double.parse(_controller.text));
  //           // });
  //         },
  //         child: const Text('Set brightness'),
  //       )
  //     ])
  //   ]
  //   )
  //   );
  // }

  // void _showToast(BuildContext context) {
  //   final scaffold = ScaffoldMessenger.of(context);
  //   scaffold.showSnackBar(
  //     SnackBar(
  //       content: const Text('Added to favorite'),
  //       action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
  //     ),
  //   );
  // }

  // FutureBuilder<String> buildFutureBuilder() {
  //   return FutureBuilder<String>(
  //     future: _futureString,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         return Text(snapshot.data!.toString());
  //       } else if (snapshot.hasError) {
  //         return Text('${snapshot.error}');
  //       }
  //
  //       return const CircularProgressIndicator();
  //     }
  //   );
  // }
}
