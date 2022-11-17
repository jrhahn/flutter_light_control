import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_light_control/light_configuration.dart';
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
  final ValueNotifier<String> _lightConfigurationNotify =
      ValueNotifier<String>("notify");

  @override
  void initState() {
    super.initState();
    _loadValue();
  }

  //Loading counter value on start
  Future<void> _loadValue() async {
    final prefs = await SharedPreferences.getInstance();

    final lightConfigurationJson = prefs.getString('lightConfiguration');

    if (lightConfigurationJson != null) {
      _lightConfigurationNotify.value =
          "${LightConfiguration.fromJson(jsonDecode(lightConfigurationJson))}";
    }
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
                    Navigator.pushNamed(context, Screen.lightSetup)
                        .then((_) => setState(() {
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

  List<Widget> _getLightControllers() {
    List<Widget> controllers = [];

    int numElements = 3;
    for (int i = 0; i < numElements; i++) {
      controllers.add(Row(children: <Widget>[
        lightNameWidget(),
        Expanded(child: LightSlider())
      ]));
    }

    controllers.add(
      Expanded(
        child: Container(
          color: Colors.amber,
          width: 100,
        ),
      ),
    );

    return controllers;
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _getLightControllers(),
      ),
    );
  }

  Widget lightNameWidget() {
    return ValueListenableBuilder(
        valueListenable: _lightConfigurationNotify,
        builder: (BuildContext context, String value, Widget? child) {
          return Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(context), body: buildBody());
  }
}
