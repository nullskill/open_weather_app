import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_app/src/feature/weather/data/weather_repository.dart';
import 'package:open_weather_app/src/feature/weather/model/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

/// Блок для работы с погодой
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final IWeatherRepository _weatherRepository;

  WeatherBloc(IWeatherRepository weatherRepository)
      : _weatherRepository = weatherRepository,
        super(const WeatherInitial()) {
    on<WeatherEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
