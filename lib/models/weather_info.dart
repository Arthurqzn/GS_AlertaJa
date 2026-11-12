class WeatherInfo {
  const WeatherInfo({required this.city, required this.temperature, required this.windSpeed, required this.humidity, required this.description});
  final String city, description;
  final double temperature, windSpeed;
  final int humidity;

  factory WeatherInfo.fromJson(String city, Map<String, dynamic> json) {
    final c = json['current'] as Map<String, dynamic>;
    final code = (c['weather_code'] as num?)?.toInt() ?? -1;
    return WeatherInfo(city: city, temperature: (c['temperature_2m'] as num).toDouble(),
      windSpeed: (c['wind_speed_10m'] as num).toDouble(),
      humidity: (c['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      description: describe(code));
  }

  static String describe(int c) {
    if (c == 0) return 'Céu limpo';
    if ([1,2,3].contains(c)) return 'Parcialmente nublado';
    if ([45,48].contains(c)) return 'Neblina';
    if ([51,53,55,56,57].contains(c)) return 'Garoa';
    if ([61,63,65,66,67,80,81,82].contains(c)) return 'Chuva';
    if ([95,96,99].contains(c)) return 'Trovoadas';
    return 'Condição não identificada';
  }
}
