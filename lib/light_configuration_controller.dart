import 'package:flutter/material.dart';
import 'package:flutter_light_control/light_configuration.dart';
import 'package:flutter_light_control/utils.dart';

class LightConfigurationController {
  late TextEditingController controllerName;
  late TextEditingController controllerIpAddress;

  late LightConfiguration config;
  String id = getRandomString(32);

  LightConfigurationController(LightConfiguration config) {
    this.config = config;

    this.controllerName = TextEditingController();
    this.controllerIpAddress = TextEditingController();

    this.controllerName.text = config.name;
    this.controllerIpAddress.text = config.ipAddress;
  }
}
