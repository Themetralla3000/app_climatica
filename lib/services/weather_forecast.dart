class WeatherForecast {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String iconCode;

  WeatherForecast({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.iconCode,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
    );
  }
}
