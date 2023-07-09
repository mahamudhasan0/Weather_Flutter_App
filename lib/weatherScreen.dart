import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreenApp extends StatefulWidget {
  const WeatherScreenApp({Key? key}) : super(key: key);

  @override
  _WeatherScreenAppState createState() => _WeatherScreenAppState();
}

class _WeatherScreenAppState extends State<WeatherScreenApp> {
  String locationName = '';
  String temperature = '';
  String minTemperature = '';
  String maxTemperature = '';
  String weatherDescription = '';
  String weatherIcon = '';
  bool isLoading = true;
  bool isError = false;

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
          isLoading = false;
          isError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
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
            : isError
                ? const Center(
                    child: Text(
                      'Error fetching the weather data',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        locationName,
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
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
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Column(
                            children: [
                              Text(
                                'min: $minTemperature°C',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.amberAccent,
                                ),
                              ),
                              Text(
                                'max: $maxTemperature°C',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.amberAccent,
                                ),
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
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                          fontFamily: 'Poppins',
                        ),
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
