import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_app/src/feature/weather/data/weather_repository.dart';
import 'package:open_weather_app/src/feature/weather/model/weather.dart';
import 'package:open_weather_app/src/feature/weather/model/weather_forecast.dart';

part 'weather_event.dart';
part 'weather_state.dart';

/// Блок для работы с погодой
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final IWeatherRepository _weatherRepository;

  WeatherBloc(this._weatherRepository) : super(const WeatherInitial()) {
    on<WeatherLoadStarted>((event, emit) async {
      emit(const WeatherLoadInProgress());
      try {
        final weatherData = await _weatherRepository.getWeatherData(event.coord);
        final weatherForecast = await _weatherRepository.getWeatherForecast(event.coord);
        emit(WeatherLoadSuccess(weatherData: weatherData, weatherForecast: weatherForecast));
      } on Object catch (e) {
        emit(WeatherLoadFailure(e.toString()));
      }
    });
  }
}
