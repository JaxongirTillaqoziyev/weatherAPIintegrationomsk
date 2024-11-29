import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {
  runApp(WeatherApp());
}
class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherHomePage(),
    );
  }
}
class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}
class _WeatherHomePageState extends State<WeatherHomePage> {
  final String apiKey = "446b421f56e34552922105114221006"; // Replace with your WeatherAPI key
  String city = "Омск";
  Map<String, dynamic>? weatherData;
  @override
  void initState() {
    super.initState();
    fetchWeather();
  }
  Future<void> fetchWeather() async {
    final url =
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Пагода $city"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Введите название города"),
              onSubmitted: (value) {
                setState(() {
                  city = value;
                  weatherData = null;
                  fetchWeather();
                });
              },
            ),
            SizedBox(height: 20),
            weatherData == null
                ? CircularProgressIndicator()
                : Column(
              children: [
                Text(
                  "Температура: ${weatherData!['current']['temp_c']}°C",
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  "Состояние: ${weatherData!['current']['condition']['text']}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
