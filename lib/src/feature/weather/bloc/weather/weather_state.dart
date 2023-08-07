part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoadInProgress extends WeatherState {
  const WeatherLoadInProgress();
}

class WeatherLoadSuccess extends WeatherState {
  final WeatherData weatherData;
  final WeatherForecast weatherForecast;

  const WeatherLoadSuccess({required this.weatherData, required this.weatherForecast});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is WeatherLoadSuccess &&
      other.weatherData == weatherData &&
      other.weatherForecast == weatherForecast;
  }

  @override
  int get hashCode => weatherData.hashCode ^ weatherForecast.hashCode;
}

class WeatherLoadFailure extends WeatherState {
  final String message;

  const WeatherLoadFailure(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is WeatherLoadFailure &&
      other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
