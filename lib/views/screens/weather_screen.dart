import 'package:dars50/models/weather.dart';
import 'package:dars50/view_models/weather_viewmodel.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final cityController = TextEditingController(text: "Tashkent");
  final weatherViewmodel = WeatherViewmodel();
  Weather? weather;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getWeather();
  }

  void getWeather() async {
    setState(() {
      isLoading = true;
    });
    weather = await weatherViewmodel.getWeather(cityController.text);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade100,
        title: const Text("Weather"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: cityController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Shahar nomi",
              suffixIcon: IconButton(
                onPressed: getWeather,
                icon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : weather == null
                  ? const Center(
                      child: Text(
                        "Shahar topilmadi.\nBoshqa shahar nomini kiriting!",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          weather!.city,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weather!.temperature.toString(),
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            const Text(
                              "℃",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weather!.description,
                              style: const TextStyle(fontSize: 20),
                            ),
                            Image.network(
                              "https://openweathermap.org/img/wn/${weather!.icon}@2x.png",
                              width: 40,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress != null) {
                                  return const CircularProgressIndicator();
                                }

                                return child;
                              },
                            ),
                          ],
                        ),
                      ],
                    )
        ],
      ),
    );
  }
}
