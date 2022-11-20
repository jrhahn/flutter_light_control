import 'package:http/http.dart' as http;

import 'package:logger/logger.dart';

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
