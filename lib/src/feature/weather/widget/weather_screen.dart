import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_weather_app/src/common/theme/theme.dart';
import 'package:open_weather_app/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:open_weather_app/src/feature/weather/bloc/location/location_bloc.dart';
import 'package:open_weather_app/src/feature/weather/bloc/weather/weather_bloc.dart';
import 'package:open_weather_app/src/feature/weather/data/weather_repository.dart';
import 'package:open_weather_app/src/feature/weather/model/weather.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: WeatherScreen());

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final WeatherBloc weatherBloc;

  @override
  void initState() {
    super.initState();

    weatherBloc = WeatherBloc(context.read<WeatherRepository>());
  }

  @override
  void dispose() {
    weatherBloc.close();

    super.dispose();
  }

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
            body = const Text('Получение местоположения');
          } else if (state is LocationLoadSuccess) {
            final Position(latitude: lat, longitude: lon) = state.position;
            weatherBloc.add(WeatherLoadStarted(Coord(lon: lon, lat: lat)));
            body = const _Body();
          } else if (state is LocationLoadFailure) {
            body = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Не удалось получить местоположение'),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.read<LocationBloc>().add(const LocationStarted()),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 8),
                      Text('Повторить'),
                    ],
                  ),
                ),
              ],
            );
          } else {
            body = const CircularProgressIndicator();
          }

          return BlocProvider.value(
            value: weatherBloc,
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Colors.white,
                      secondary: Colors.white,
                    ),
                textTheme: TextTheme(
                  headlineLarge: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                      ),
                  titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          SvgPicture.asset('assets/images/pin.svg'),
                          const SizedBox(width: 8),
                          Text(
                            state is WeatherLoadSuccess ? state.weatherData.name : '',
                          ),
                        ],
                      );
                    },
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () => context.read<AuthenticationBloc>().add(
                            const AuthenticationLogoutRequested(),
                          ),
                    ),
                  ],
                ),
                body: Center(child: body),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state is WeatherLoadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is WeatherLoadSuccess) {
          final Main(:temp, :tempMin, :tempMax) = state.weatherData.main;
          final description = state.weatherData.weather.first.description;

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 270,
                  width: 270,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.9),
                                Colors.white.withOpacity(0.5),
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                                Colors.transparent,
                              ],
                              center: Alignment.center,
                              radius: 0.5,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'assets/images/rain.png',
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${temp.toInt()}°',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 64),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Макс.: ${tempMin.toInt()}° Мин: ${tempMax.toInt()}°',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    const _Forecast(),
                    const SizedBox(height: 24),
                    const _WindAndHumidity(),
                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          );
        } else if (state is WeatherLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoadFailure) {
          return Text('Не удалось получить погоду:\n${state.message}');
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _Forecast extends StatelessWidget {
  const _Forecast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Сегодня',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '20 марта',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.white.withOpacity(0.8),
            thickness: 1,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 142,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index == 2) {
                    return const _CurrentHourWeather();
                  }
                  return const _HourWeather();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HourWeather extends StatelessWidget {
  const _HourWeather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '12:00',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          SvgPicture.asset(
            'assets/images/sun_small.svg',
            height: 32,
            width: 32,
          ),
          const SizedBox(height: 16),
          Text(
            '12°',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _CurrentHourWeather extends StatelessWidget {
  const _CurrentHourWeather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.white.withOpacity(0.8),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '12:00',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          SvgPicture.asset(
            'assets/images/sun_small.svg',
            height: 32,
            width: 32,
          ),
          const SizedBox(height: 16),
          Text(
            '12°',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _WindAndHumidity extends StatelessWidget {
  const _WindAndHumidity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.3),
        );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 88,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/images/wind.svg'),
                    const SizedBox(width: 8),
                    Text(
                      '2 м/с',
                      style: valueStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                  child: Text(
                'Ветер северо-восточный',
                style: Theme.of(context).textTheme.titleMedium,
              )),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              SizedBox(
                width: 88,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/images/drop.svg'),
                    const SizedBox(width: 8),
                    Text(
                      '100%',
                      style: valueStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                  child: Text(
                'Высокая влажность',
                style: Theme.of(context).textTheme.titleMedium,
              )),
            ],
          ),
        ],
      ),
    );
  }
}
