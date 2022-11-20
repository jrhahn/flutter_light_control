import 'package:flutter_light_control/light_configuration.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

var logger = Logger();

Future<Map<String, LightConfiguration>> loadLightConfigurations() async {
  final prefs = await SharedPreferences.getInstance();

  final serializedConfigs = prefs.getString('lightConfiguration') ?? "{}";
  try {
    final configs = jsonDecode(serializedConfigs) ?? {};

    logger.d(configs);

    Map<String, LightConfiguration> result = {};

    configs.forEach((id, config) {
      result[id] = LightConfiguration.fromJson(config);
    });

    return result;
  } on FormatException catch (e) {
    logger.e("$e (json: $serializedConfigs)");
  }

  return {};
}
