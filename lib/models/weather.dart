import 'dart:convert';

class Weather {
  String city;
  String description;
  int temperature;
  String icon;
  Weather({
    required this.city,
    required this.description,
    required this.temperature,
    required this.icon,
  });

  Weather copyWith({
    String? city,
    String? description,
    int? temperature,
    String? icon,
  }) {
    return Weather(
      city: city ?? this.city,
      description: description ?? this.description,
      temperature: temperature ?? this.temperature,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'city': city});
    result.addAll({'description': description});
    result.addAll({'temperature': temperature});
    result.addAll({'icon': icon});

    return result;
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      city: map['name'] ?? '',
      description: map['weather'][0]['main'] ?? '',
      temperature: map['main']['temp']?.toInt() ?? 0,
      icon: map['weather'][0]['icon'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Weather.fromJson(String source) =>
      Weather.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Weather(city: $city, description: $description, temperature: $temperature, icon: $icon)';
  }
}
