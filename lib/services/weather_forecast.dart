class ForecastPoint {
  final double temperature;
  final String weatherMain;
  final DateTime timestamp;

  ForecastPoint({
    required this.temperature,
    required this.weatherMain,
    required this.timestamp,
  });

  factory ForecastPoint.fromJson(Map<String, dynamic> json) {
    return ForecastPoint(
      temperature: (json['main']['temp'] as num).toDouble(),
      weatherMain: json['weather'][0]['main'],
      timestamp: DateTime.parse(json['dt_txt']),
    );
  }
}

