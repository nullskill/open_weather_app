part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {
  const WeatherEvent();
}

class WeatherLoadStarted extends WeatherEvent {
  final Coord coord;

  const WeatherLoadStarted(this.coord);
}
