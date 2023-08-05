import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_weather_app/src/feature/weather/bloc/location/location_bloc.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Main(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc()..add(const LocationStarted()),
      child: Scaffold(
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
                child: Text(
                  'Location: ($lat, $lon)',
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
