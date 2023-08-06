import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_app/src/feature/authentication/bloc/authentication/authentication_bloc.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: WeatherScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AuthenticationBloc>().add(const AuthenticationLogoutRequested()),
          )
        ],
      ),
      body: const Center(
        child: Text('Weather screen'),
      ),
    );
  }
}
