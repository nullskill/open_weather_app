import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_weather_app/src/common/theme/theme.dart';
import 'package:open_weather_app/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:open_weather_app/src/feature/weather/bloc/location/location_bloc.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: WeatherScreen());

  @override
  Widget build(BuildContext context) {
    final gradientColor = kGradientColor.withOpacity(0.4392);

    return BlocProvider(
      create: (context) => LocationBloc()..add(const LocationStarted()),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientColor, gradientColor, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BlocConsumer<LocationBloc, LocationState>(listener: (context, state) {
          if (state is LocationLoadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        }, builder: (context, state) {
          late final Widget body;
          if (state is LocationInitial) {
            body = const Center(child: Text('Получение местоположения'));
          } else if (state is LocationLoadSuccess) {
            final Position(latitude: lat, longitude: lon) = state.position;
            body = Center(
              child: Column(
                children: [
                  Text(
                    'Location: ($lat, $lon)',
                  ),
                  Image.asset('assets/images/sun.png'),
                ],
              ),
            );
          } else if (state is LocationLoadFailure) {
            body = const Center(child: Text('Не удалось получить местоположение'));
          } else {
            body = const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Weather'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () => context.read<AuthenticationBloc>().add(const AuthenticationLogoutRequested()),
                )
              ],
            ),
            body: body,
          );
        }),
      ),
    );
  }
}
