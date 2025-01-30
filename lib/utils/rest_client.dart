import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:vvcmc_citizen_app/models/temperature.dart';

class RestClient {
  Future<Temperature?> getTemperature() async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=Virar&units=metric&appid=68ea5c29ae01ef17b78929a7cbbe6b17"));
      return Temperature.fromMap(jsonDecode(response.body));
    } catch (error) {
      log("$error");
      return null;
    }
  }
}
