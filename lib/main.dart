import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_app/firebase_options.dart';
import 'package:open_weather_app/src/common/routes/routes.dart';
import 'package:open_weather_app/src/common/theme/theme.dart';
import 'package:open_weather_app/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:open_weather_app/src/feature/authentication/data/authentication_repository.dart';

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
    return MaterialApp(
      theme: appTheme,
      home: FlowBuilder<AuthStatus>(
        state: context.select((AuthenticationBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
