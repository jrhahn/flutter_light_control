import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import './light_status.dart';

var logger = Logger();

Future<bool> setBrightness(
  double brightness,
  String ipAddress,
) async {
  final brightnessClamped = brightness.clamp(0.0, 1.0);

  try {
    final response = await http.post(
      Uri.parse('http://$ipAddress/set_brightness'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'brightness': brightnessClamped.toString(),
      },
    );

    if (response.statusCode != 200) {
      logger.e('Failed to set brightness (error code ${response.statusCode}).');
      return false;
    }
  } catch (e) {
    logger.e(e);
    return false;
  }

  return true;
}

Future<double> getBrightness(
  String ipAddress,
) async {
  const defaultValue = 0.2;

  try {
    final response = await http.get(
      Uri.parse('http://$ipAddress/get_brightness'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode != 200) {
      logger.e('Failed to set brightness (error code ${response.statusCode}).');
      return defaultValue;
    }

    print(response.body);

    final Map<String, dynamic> content = jsonDecode(response.body);

    final lightStatus = LightStatus.fromJson(content);

    return lightStatus.brightness;
  } catch (e) {
    logger.e(e);
    return defaultValue;
  }
}
