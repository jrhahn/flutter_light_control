import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../widget/light_slider.dart';

// This is the type used by the popup menu below.
enum Menu { itemSetting }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<String> _notify = ValueNotifier<String>("notify");

  @override
  void initState() {
    super.initState();
    _loadValue();
  }

  @override


  //Loading counter value on start
  Future<void> _loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    _notify.value = prefs.getString('url') ?? _notify.value;
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(appTitle),
      actions: <Widget>[
        PopupMenuButton<Menu>(
            onSelected: (Menu item) {
              switch (item) {
                case Menu.itemSetting:
                  {
                    Navigator.pushNamed(context, Screen.lightSetup).then((_) => setState(() {
                        _loadValue();
                    }));
                  }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
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
        children: <Widget>[
          lightNameWidget(),
          const LightSlider(),
        ],
      ),
      //
    );
  }

  Widget lightNameWidget() {
    return ValueListenableBuilder(
        valueListenable: _notify,
        builder: (BuildContext context, String value, Widget? child) {
          return Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(context), body: buildBody());
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
