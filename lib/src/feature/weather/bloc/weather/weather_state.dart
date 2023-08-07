part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {
  const WeatherState();
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}
