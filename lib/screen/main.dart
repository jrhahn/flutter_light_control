import 'package:flutter/material.dart';
import 'package:flutter_light_control/light_control_controller.dart';
import 'package:flutter_light_control/storage.dart';

import '../constants.dart';
import '../widget/light_slider.dart';

enum Menu { itemSetting }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, LightControlController> controller = {};

  @override
  void initState() {
    super.initState();
    _generateLightControlControllers();
  }

  @override
  void dispose() {
    controller.forEach((id, control) {
      control.controllerName.dispose();
      control.controllerIpAddress.dispose();
    });

    super.dispose();
  }

  Future<void> _generateLightControlControllers() async {
    controller.clear();
    final configs = await loadLightConfigurations();

    configs.forEach((id, config) {
      controller[id] = LightControlController(config);
    });
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
                              _generateLightControlControllers();
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

  List<Widget> _buildLightControlWidgets() {
    List<Widget> widgets = [];

    if (controller.isNotEmpty) {
      controller.forEach((id, controller) {
        widgets.add(Row(
          children: [
            lightNameWidget(controller.controllerName.text),
            Expanded(
                child: LightSlider(
              ipAddress: controller.controllerIpAddress.text,
            )),
          ],
        ));
      });
    } else {
      widgets.add(Container(height: 100));
      widgets.add(const Align(
          alignment: Alignment.center,
          child: Text(
            "Click on the menu in the upper right corner to set up a new light.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          )));
    }

    widgets.add(
      Expanded(
        child: Container(
          width: 100,
        ),
      ),
    );

    return widgets;
  }

  Widget buildBody() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildLightControlWidgets(),
      ),
    );
  }

  Widget lightNameWidget(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.left,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(context), body: buildBody());
  }
}
