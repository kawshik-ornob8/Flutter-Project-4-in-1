import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WeatherPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _weatherData = '';
  String _locationName = '';
  bool _isLoading = false;
  bool _hasError = false;
  TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeatherDataFromLocation();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeatherDataFromLocation() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Request location permissions
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _weatherData = 'Location permission denied';
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Fetch location name
      final locationName =
          await _fetchLocationName(position.latitude, position.longitude);

      final apiKey =
          '9ac983a365eaf250d5c38fc21578451f'; // Replace with your OpenWeatherMap API key
      final openWeatherMapUrl =
          'http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric';

      final openWeatherMapResponse =
          await http.get(Uri.parse(openWeatherMapUrl));
      if (openWeatherMapResponse.statusCode == 200) {
        final openWeatherMapData = json.decode(openWeatherMapResponse.body);
        final weatherDescription =
            openWeatherMapData['weather'][0]['description'];
        final temperature = openWeatherMapData['main']['temp'];
        final humidity = openWeatherMapData['main']['humidity'];

        // Fetch UV index
        final uvIndex =
            await _fetchUVIndex(position.latitude, position.longitude);

        setState(() {
          _isLoading = false;
          _weatherData =
              'Weather: $weatherDescription\nTemperature: $temperature°C\nHumidity: $humidity%\nUV Index: $uvIndex';
          _locationName = locationName;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _weatherData = 'Failed to load weather data';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _weatherData = 'Error fetching weather data: $error';
      });
    }
  }

  Future<String> _fetchLocationName(double latitude, double longitude) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json&zoom=10';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final address = jsonData['display_name'];
      return address;
    } else {
      return 'Unknown';
    }
  }

  Future<String> _fetchUVIndex(double latitude, double longitude) async {
    final openUVApiKey =
        '9ac983a365eaf250d5c38fc21578451f'; // Replace with your OpenUV API key
    final uvUrl =
        'https://api.openuv.io/api/v1/uv?lat=$latitude&lng=$longitude';
    final uvResponse = await http.get(
      Uri.parse(uvUrl),
      headers: {'x-access-token': openUVApiKey},
    );
    if (uvResponse.statusCode == 200) {
      final uvData = json.decode(uvResponse.body);
      final uvIndex = uvData['result']['uv'];
      return uvIndex.toString();
    } else {
      return 'Unknown';
    }
  }

  Future<void> _fetchWeatherDataFromCity(String cityName) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiKey =
          '9ac983a365eaf250d5c38fc21578451f'; // Replace with your OpenWeatherMap API key
      final url =
          'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final weatherDescription = jsonData['weather'][0]['description'];
        final temperature = jsonData['main']['temp'];
        final humidity = jsonData['main']['humidity'];

        setState(() {
          _isLoading = false;
          _weatherData =
              'Weather: $weatherDescription\nTemperature: $temperature°C\nHumidity: $humidity%';
          _locationName = cityName;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _weatherData = 'Failed to load weather data';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _weatherData = 'Error fetching weather data: $error';
      });
    }
  }

  Icon _getWeatherIcon(String weatherData) {
    String weatherLowerCase = weatherData.toLowerCase();
    if (weatherLowerCase.contains('haze')) {
      return Icon(WeatherIcons.fog, size: 64.0, color: Colors.grey);
    } else if (weatherLowerCase.contains('cloud')) {
      return Icon(WeatherIcons.cloud, size: 64.0, color: Colors.blueGrey);
    } else if (weatherLowerCase.contains('rain')) {
      return Icon(WeatherIcons.rain, size: 64.0, color: Colors.blue);
    } else if (weatherLowerCase.contains('snow')) {
      return Icon(WeatherIcons.snow, size: 64.0, color: Colors.lightBlue);
    } else if (weatherLowerCase.contains('clear')) {
      return Icon(WeatherIcons.day_sunny, size: 64.0, color: Colors.yellow);
    } else {
      return Icon(WeatherIcons.day_sunny_overcast,
          size: 64.0, color: Colors.yellow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'Enter City Name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    String cityName = _cityController.text.trim();
                    if (cityName.isNotEmpty) {
                      _fetchWeatherDataFromCity(cityName);
                    }
                  },
                  child: Text('Search'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : _hasError
                      ? Text(
                          _weatherData,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _getWeatherIcon(_weatherData),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    _weatherData,
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Location: $_locationName',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        height: 50,
        alignment: Alignment.center,
        color: Colors.grey[200],
        child: Text(
          '© 2024 Kawshik Ahmed Ornob. All rights reserved.',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
