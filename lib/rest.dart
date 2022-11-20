import 'dart:async';

import 'package:http/http.dart' as http;

void setBrightness(
  double brightness,
  String ipAddress,
) async {
  final brightnessClamped = brightness.clamp(0.0, 1.0);

  final response = await http.post(
    Uri.parse('http://$ipAddress/set_brightness'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'brightness': brightnessClamped.toString(),
    },
  );

  if (response.statusCode != 201) {
    throw Exception(
        'Failed to set brightness (error code ${response.statusCode}).');
  }
}
