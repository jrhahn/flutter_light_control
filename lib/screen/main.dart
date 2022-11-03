import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_light_control/rest.dart';

import '../constants.dart';
import '../widget/light_slider.dart';

// This is the type used by the popup menu below.
enum Menu { itemSetting }


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  AppBar buildAppBar (BuildContext context) {
    return AppBar(
      title: const Text(appTitle),
      actions: <Widget>[
// This button presents popup menu items.
        PopupMenuButton<Menu>(
// Callback that sets the selected popup menu item.
            onSelected: (Menu item) {
              switch(item) {
                case Menu.itemSetting: {
                  Navigator.pushNamed(context, Screen.lightSetup);
                }
              }
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<Menu>>[
              const PopupMenuItem<Menu>(
                value: Menu.itemSetting,
                child: Text('Settings'),
              ),
            ]),
      ],
    );
  }

  Widget buildBody() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            Text("Light 1",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 28)),
            LightSlider()
          ]),
      //
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: buildBody()
    );
  }
}


// class _MainScreenState extends State<MainScreen> {
//   // final TextEditingController _controller = TextEditingController();
//   // final TextEditingController _controller2 = TextEditingController();
//   // Future<String>? _futureString;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: appTitle,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         initialRoute: '/main',
//         routes: {
//           '/': (context) => const MainScreen(),
//         }
//     );
//   }
//
// }
