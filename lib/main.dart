import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_app/firebase_options.dart';
import 'package:open_weather_app/src/common/routes/routes.dart';
import 'package:open_weather_app/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:open_weather_app/src/feature/authentication/data/authentication_repository.dart';
import 'package:open_weather_app/src/feature/weather/bloc/location/location_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthenticationRepository(),
      child: BlocProvider(
        create: (context) => AuthenticationBloc(
          authRepository: context.read<AuthenticationRepository>(),
        ),
        child: const MaterialApp(
          home: Main(),
        ),
      ),
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
      child: const Scaffold(
        body: AppView(),
        // BlocConsumer<LocationBloc, LocationState>(
        //   listener: (context, state) {
        //     if (state is LocationLoadFailure) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text(state.message)),
        //       );
        //     }
        //   },
        //   builder: (context, state) {
        //     if (state is LocationInitial) {
        //       return const Center(child: Text('Получение местоположения'));
        //     }
        //     if (state is LocationLoadSuccess) {
        //       final Position(latitude: lat, longitude: lon) = state.position;
        //       return Center(
        //         child: Text(
        //           'Location: ($lat, $lon)',
        //         ),
        //       );
        //     }
        //     if (state is LocationLoadFailure) {
        //       return const Center(child: Text('Не удалось получить местоположение'));
        //     }
        //     return const Center(child: CircularProgressIndicator());
        //   },
        // ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlowBuilder<AuthStatus>(
        state: context.select((AuthenticationBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
