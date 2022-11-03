import 'dart:async';
import 'dart:developer';

import 'package:http/http.dart' as http;

const serverURL = "http://192.168.178.34";

Future<String> setBrightness(double brightness) async {
  final brightnessClamped = brightness.clamp(0.0, 1.0);

  try {
    final response = await http.post(
      Uri.parse('$serverURL/set_brightness'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'brightness': brightnessClamped.toString(),
      },
    );

    if (response.statusCode != 201) {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception(
          'Failed to set brightness (error code ${response.statusCode}).');
    }
  } on http.ClientException catch (e) {
    log(e.toString());
  }

  return "Brightness set to $brightness";
}
