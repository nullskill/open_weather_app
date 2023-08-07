import 'package:open_weather_app/src/common/constant%20/constants.dart';
import 'package:open_weather_app/src/common/network/api_client.dart';
import 'package:open_weather_app/src/feature/weather/model/weather.dart';
import 'package:open_weather_app/src/feature/weather/model/weather_forecast.dart';

abstract class IWeatherRepository {
  Future<WeatherData> getWeatherData(Coord coord);
  Future<WeatherForecast> getWeatherForecast(Coord coord);
}

class WeatherRepository implements IWeatherRepository {
  final ApiClient _apiClient;

  WeatherRepository(this._apiClient);

  @override
  Future<WeatherData> getWeatherData(Coord coord) async {
    final url = '${Constants.baseUrlApi}/${Constants.weatherApiVersion}/weather'
        '?lat=${coord.lat}&lon=${coord.lat}'
        '&units=${Constants.measurementUnit}'
        '&appid=${Constants.apiKey}'
        '&lang=ru';
    final response = await _apiClient.get(url);
    final weatherData = WeatherData.fromJson(response.data);

    return weatherData;
  }

  @override
  Future<WeatherForecast> getWeatherForecast(Coord coord) async {
    final url = '${Constants.baseUrlApi}/${Constants.oneCallApiVersion}/onecall'
        '?lat=${coord.lat}&lon=${coord.lat}'
        '&exclude=minutely,daily,alerts'
        '&units=${Constants.measurementUnit}'
        '&appid=${Constants.apiKey}'
        '&lang=ru';
    final response = await _apiClient.get(url);
    final weatherForecast = WeatherForecast.fromJson(response.data);

    return weatherForecast;
  }
}
