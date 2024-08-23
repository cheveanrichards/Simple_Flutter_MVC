import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import '../../../lib/controllers/models/controllers/weather_controller.dart';
import '../../../lib/controllers/models/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherController _weatherController = WeatherController();
  final TextEditingController _textController = TextEditingController();
  WeatherModel? _weather;
  String _cityName = 'London';
  List<String> _recentCities = ['London', 'New York', 'Tokyo', 'Paris', 'Sydney'];

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadWeather() async {
    try {
      final weather = await _weatherController.getWeather(_cityName);
      setState(() {
        _weather = weather;
        if (!_recentCities.contains(_cityName)) {
          _recentCities.insert(0, _cityName);
          if (_recentCities.length > 5) {
            _recentCities.removeLast();
          }
        }
      });
    } catch (e) {
      print('Error loading weather: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load weather data')),
      );
    }
  }

  IconData _getWeatherIcon(String condition) {
    condition = condition.toLowerCase();

    if (RegExp(r'sun|clear|fair').hasMatch(condition)) {
      return WeatherIcons.day_sunny;
    } else if (RegExp(r'rain|drizzle|shower').hasMatch(condition)) {
      return WeatherIcons.rain;
    } else if (RegExp(r'cloud|overcast').hasMatch(condition)) {
      return WeatherIcons.cloud;
    } else if (RegExp(r'thunder|lightning|storm').hasMatch(condition)) {
      return WeatherIcons.thunderstorm;
    } else if (RegExp(r'snow|sleet|hail|ice').hasMatch(condition)) {
      return WeatherIcons.snow;
    } else if (RegExp(r'mist|fog|haze').hasMatch(condition)) {
      return WeatherIcons.fog;
    } else {
      return WeatherIcons.na;
    }
  }

  double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  double celsiusToKelvin(double celsius) {
    return celsius + 273.15;
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter city, country',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _cityName = _textController.text;
                    });
                    _loadWeather();
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _cityName,
              items: _recentCities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _cityName = newValue;
                    _textController.text = newValue;
                  });
                  _loadWeather();
                }
              },
            ),
          ),
          Expanded(
            child: Center(
              child: _weather == null
                  ? CircularProgressIndicator()
                  : Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BoxedIcon(
                                _getWeatherIcon(_weather!.description),
                                size: 80,
                                color: Colors.blue,
                              ),
                              SizedBox(height: 24),
                              Text(
                                _weather!.cityName,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              SizedBox(height: 16),
                              Text(
                                '${_weather!.temperature.toStringAsFixed(1)}°C',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${celsiusToFahrenheit(_weather!.temperature).toStringAsFixed(1)}°F',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${celsiusToKelvin(_weather!.temperature).toStringAsFixed(1)}K',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(height: 16),
                              Text(
                                _weather!.description,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadWeather,
        child: Icon(Icons.refresh),
      ),
    );
  }
}