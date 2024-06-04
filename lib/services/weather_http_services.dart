import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dars50/models/weather.dart';

class WeatherHttpServices {
  Future<Weather?> getWeather(String city) async {
    Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=4fbcaea02da3f8d21a4ac27cfc5dca4c");

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data != null) {
        return Weather.fromMap(data);
      }
    } catch (e) {
      print(e);
    }
  }
}
