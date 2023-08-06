import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_weather_app/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:open_weather_app/src/feature/weather/bloc/location/location_bloc.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: WeatherScreen());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc()..add(const LocationStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weather'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => context.read<AuthenticationBloc>().add(const AuthenticationLogoutRequested()),
            )
          ],
        ),
        body: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationLoadFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is LocationInitial) {
              return const Center(child: Text('Получение местоположения'));
            }
            if (state is LocationLoadSuccess) {
              final Position(latitude: lat, longitude: lon) = state.position;
              return Center(
                child: Column(
                  children: [
                    Text(
                      'Location: ($lat, $lon)',
                    ),
                    Image.asset('assets/images/sun.png'),
                  ],
                ),
              );
            }
            if (state is LocationLoadFailure) {
              return const Center(child: Text('Не удалось получить местоположение'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
