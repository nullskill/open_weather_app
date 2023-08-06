import 'package:flutter/widgets.dart';
import 'package:open_weather_app/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:open_weather_app/src/feature/authentication/widget/login_screen.dart';
import 'package:open_weather_app/src/feature/weather/widget/weather_screen.dart';

List<Page> onGenerateAppViewPages(
  AuthStatus status,
  List<Page<dynamic>> pages,
) {
  return switch (status) {
    AuthStatus.authenticated => [WeatherScreen.page()],
    _ => [LoginScreen.page()],
  };
}
