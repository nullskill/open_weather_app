/// Погода с прогнозом по часам
class WeatherForecast {
  final double lat;
  final double lon;
  final String timezone;
  final int timezoneOffset;
  final CurrentWeather currentWeather;
  final List<HourlyWeather> hourlyWeather;

  WeatherForecast({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.timezoneOffset,
    required this.currentWeather,
    required this.hourlyWeather,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    var list = json['hourly'] as List;
    List<HourlyWeather> hourlyWeatherList = list.map((i) => HourlyWeather.fromJson(i)).toList();

    return WeatherForecast(
      lat: json['lat'],
      lon: json['lon'],
      timezone: json['timezone'],
      timezoneOffset: json['timezone_offset'],
      currentWeather: CurrentWeather.fromJson(json['current']),
      hourlyWeather: hourlyWeatherList,
    );
  }

  String toString() {
    return 'WeatherForecast{lat: $lat, lon: $lon, timezone: $timezone, timezoneOffset: $timezoneOffset, '
        'currentWeather: $currentWeather, hourlyWeather: $hourlyWeather}';
  }
}

class CurrentWeather {
  final int dt;
  final int sunrise;
  final int sunset;
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final double uvi;
  final int clouds;
  final int visibility;
  final double windSpeed;
  final int windDeg;

  CurrentWeather({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      dt: json['dt'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      temp: json['temp'],
      feelsLike: json['feels_like'],
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'],
      uvi: json['uvi'],
      clouds: json['clouds'],
      visibility: json['visibility'],
      windSpeed: json['wind_speed'],
      windDeg: json['wind_deg'],
    );
  }
}

class HourlyWeather {
  final int dt;
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final double uvi;
  final int clouds;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final double windGust;
  final double pop;

  HourlyWeather({
    required this.dt,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.windGust,
    required this.pop,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      dt: json['dt'],
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: (json['dew_point'] as num).toDouble(),
      uvi: (json['uvi'] as num).toDouble(),
      clouds: json['clouds'],
      visibility: json['visibility'],
      windSpeed: (json['wind_speed'] as num).toDouble(),
      windDeg: json['wind_deg'],
      windGust: (json['wind_gust'] as num).toDouble(),
      pop: (json['pop'] as num).toDouble(),
    );
  }
}