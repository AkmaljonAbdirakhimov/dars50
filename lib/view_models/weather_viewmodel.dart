import 'package:dars50/models/weather.dart';
import 'package:dars50/services/weather_http_services.dart';

class WeatherViewmodel {
  final weatherHttpServices = WeatherHttpServices();

  Future<Weather?> getWeather(String city) async {
    return weatherHttpServices.getWeather(city);
  }
}
