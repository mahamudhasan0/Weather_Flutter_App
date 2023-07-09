import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreenApp extends StatefulWidget {
  const WeatherScreenApp({super.key});

  @override
  _WeatherScreenApp createState() => _WeatherScreenApp();
}

class _WeatherScreenApp extends State<WeatherScreenApp> {
  String locationName = '';
  String temperature = '';
  String minTemperature = '';
  String maxTemperature = '';
  String weatherDescription = '';
  String weatherIcon = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    weatherData();
  }

  Future<void> weatherData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=Magura&units=metric&APPID=43ea6baaad7663dc17637e22ee6f78f2'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final mainData = jsonData['main'];
        final weatherData = jsonData['weather'][0];

        setState(() {
          locationName = jsonData['name'];
          temperature = mainData['temp'].toStringAsFixed(1);
          minTemperature = mainData['temp_min'].toStringAsFixed(1);
          maxTemperature = mainData['temp_max'].toStringAsFixed(1);
          weatherDescription = weatherData['description'];
          weatherIcon = weatherData['icon'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purpleAccent,
              Colors.lightBlue,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    locationName,
                    style: const TextStyle(
                      fontSize: 30.0,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150.0,
                        width: 150.0,
                        child: Image.network(
                          getWeatherImageUrl(weatherIcon),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        ' $temperature°C',
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.yellowAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20.0),
                      Column(
                        children: [
                          Text(
                            'min: $minTemperature°C',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.amberAccent),
                          ),
                          Text(
                            'max: $maxTemperature°C',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.amberAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    weatherDescription,
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white54,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }

  String getWeatherImageUrl(String iconCode) {
    return 'https://openweathermap.org/img/w/$iconCode.png';
  }
}
