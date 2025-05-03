

import 'dart:convert';

import 'package:app_climatica/services/weather.dart';
import 'package:app_climatica/services/weather_forecast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService{
  final String baseUrl="https://api.openweathermap.org/data/2.5";


  Future<Weather> fetchWeatherByCity(String cityName) async {
    final apiKey= dotenv.env['api_key'];
    final url= Uri.parse('$baseUrl/weather?q=$cityName&units=metric&lang=es&appid=$apiKey');

    final response = await http.get(url);
    if( response.statusCode==200){

      final jsonData = json.decode(response.body);
      return Weather.fromJson(jsonData);
    }else throw Exception("error loading weather data from city");

  }

  Future<Weather> fetchWeatherByLocation(Position position) async{
    final lat=position.latitude;
    final lon=position.longitude;
    final apiKey= dotenv.env['api_key'];
    final url =Uri.parse('$baseUrl/weather?lat=$lat&lon=$lon&units=metric&lang=es&appid=$apiKey');

    final response = await http.get(url);
    if(response.statusCode==200){
      final jsonData= json.decode(response.body);
      return Weather.fromJson(jsonData);
    }
    else throw Exception("error loading weather data from location");
  }

  Future<dynamic> fetchForecastByCity(String city) async{
    final apiKey=dotenv.env['api_key'];
    final url =Uri.parse('$baseUrl/forecast?q=$city&appid=$apiKey&units=metric&lang=es');

    final response =await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> forecastList = data['list'];
      return forecastList
          .map((item) => ForecastPoint.fromJson(item))
          .toList();
    }
    else{
      throw Exception("error loading forecast from city");
    }

  }

  Future<List<ForecastPoint>> fetchForecastByLocation(Position position) async{
    final lat=position.latitude;
    final lon=position.longitude;
    final apiKey= dotenv.env['api_key'];
    final url =Uri.parse('$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&lang=es&appid=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> forecastList = data['list'];
      return forecastList
          .map((item) => ForecastPoint.fromJson(item))
          .toList();
    }
    else throw Exception("error loading weather data from location");
  }

  }

