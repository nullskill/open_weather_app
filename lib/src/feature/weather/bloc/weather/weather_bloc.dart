import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'weather_event.dart';
part 'weather_state.dart';

/// Блок для работы с погодой
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(const WeatherInitial()) {
    on<WeatherEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
