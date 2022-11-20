import 'package:flutter/material.dart';
import 'package:flutter_light_control/light_configuration.dart';

enum Menu { itemSetting }

class LightControlController {
  late TextEditingController controllerName;
  late TextEditingController controllerIpAddress;

  late LightConfiguration config;

  LightControlController(LightConfiguration config) {
    this.config = config;

    controllerName = TextEditingController();
    controllerIpAddress = TextEditingController();

    controllerName.text = config.name;
    controllerIpAddress.text = config.ipAddress;
  }
}
