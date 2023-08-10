import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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

    return MaterialApp(
      theme: darkTheme,
      home: BlocProvider(
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
              body = const SliverToBoxAdapter(child: SizedBox.shrink());
            } else if (state is LocationLoadSuccess) {
              final Position(latitude: lat, longitude: lon) = state.position;
              weatherBloc.add(WeatherLoadStarted(Coord(lon: lon, lat: lat)));
              body = const _Body();
            } else if (state is LocationLoadFailure) {
              body = SliverFillRemaining(
                child: Center(
                  child: Column(
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
                  ),
                ),
              );
            } else {
              body = const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return BlocProvider.value(
              value: weatherBloc,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
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
                    body,
                  ],
                ),
              ),
              // ),
            );
          }),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  String _getWeatherImage(String weatherName) {
    switch (weatherName) {
      case 'Thunderstorm':
        return 'assets/images/thunderstorm.png';
      case 'Drizzle':
        return 'assets/images/drizzle.png';
      case 'Rain':
        return 'assets/images/rain.png';
      case 'Snow':
        return 'assets/images/snow.png';
      case 'Clouds':
        return 'assets/images/clouds.png';
      case 'Clear':
      default:
        return 'assets/images/clear.png';
    }
  }

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
          final Weather(main: weatherName, :description) = state.weatherData.weather.first;

          return SliverToBoxAdapter(
            child: Center(
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
                                  kWhiteColor.withOpacity(0.9),
                                  kWhiteColor.withOpacity(0.5),
                                  kWhiteColor.withOpacity(0.3),
                                  kWhiteColor.withOpacity(0.2),
                                  kWhiteColor.withOpacity(0.1),
                                  kWhiteColor.withOpacity(0.05),
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
                            _getWeatherImage(weatherName),
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
                        description.characters.first.toUpperCase() + description.substring(1),
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
            ),
          );
        } else if (state is WeatherLoadInProgress) {
          return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
        } else if (state is WeatherLoadFailure) {
          return SliverFillRemaining(
            child: Center(
              child: Text('Не удалось получить погоду:\n${state.message}'),
            ),
          );
        } else {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
      },
    );
  }
}

class _Forecast extends StatelessWidget {
  const _Forecast({Key? key}) : super(key: key);

  int _getHourOfDay(int dt) {
    final date = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    return date.hour;
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    final now = DateTime.now();
    final formatter = DateFormat('d MMMM', 'ru');
    final formattedDate = formatter.format(now);

    final state = context.read<WeatherBloc>().state as WeatherLoadSuccess;
    final hourlyWeather = state.weatherForecast.hourlyWeather;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kWhiteColor.withOpacity(0.2),
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
                  formattedDate,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Divider(
            color: kWhiteColor.withOpacity(0.8),
            thickness: 1,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 142,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hourlyWeather.length,
                itemBuilder: (context, index) {
                  final hourWeather = hourlyWeather[index];
                  final hourOfDay = _getHourOfDay(hourWeather.dt);
                  return _HourWeather(
                    hourOfDay: hourOfDay,
                    temperature: hourWeather.temp.toInt(),
                    weather: hourWeather.weather,
                    isCurrent: hourOfDay == now.hour,
                  );
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
  final int hourOfDay;
  final int temperature;
  final Weather weather;
  final bool isCurrent;

  const _HourWeather({
    Key? key,
    required this.hourOfDay,
    required this.temperature,
    required this.weather,
    required this.isCurrent,
  }) : super(key: key);

  String _getWeatherImage() {
    switch (weather.main) {
      case 'Thunderstorm':
        return 'assets/images/thunderstorm.svg';
      case 'Rain':
        return 'assets/images/rain.svg';
      case 'Snow':
        return 'assets/images/snow.svg';
      case 'Clouds':
        if (hourOfDay > 6 && hourOfDay < 20) {
          return 'assets/images/cloud_day.svg';
        } else {
          return 'assets/images/cloud_night.svg';
        }
      case 'Clear':
      default:
        return 'assets/images/clear.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: isCurrent
          ? BoxDecoration(
              color: kWhiteColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.fromBorderSide(
                BorderSide(
                  color: kWhiteColor.withOpacity(0.8),
                  width: 1,
                ),
              ),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$hourOfDay:00',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          SvgPicture.asset(
            _getWeatherImage(),
            height: 32,
            width: 32,
          ),
          const SizedBox(height: 16),
          Text(
            '$temperature°',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _WindAndHumidity extends StatelessWidget {
  const _WindAndHumidity({Key? key}) : super(key: key);

  String _getWindDirection(int windDegree) {
    const directions = [
      'северный',
      'северо-восточный',
      'восточный',
      'юго-восточный',
      'южный',
      'юго-западный',
      'западный',
      'северо-западный',
      'северный'
    ];

    final index = ((windDegree / 45) + 0.5).floor() % 8;
    return directions[index];
  }

  String _getHumidityLevel(int humidity) {
    if (humidity < 30) {
      return 'Низкая влажность';
    } else if (humidity < 60) {
      return 'Средняя влажность';
    } else {
      return 'Высокая влажность';
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: kWhiteColor.withOpacity(0.3),
        );

    final state = context.read<WeatherBloc>().state as WeatherLoadSuccess;
    final humidity = state.weatherForecast.currentWeather.humidity;
    final humidityLevel = _getHumidityLevel(humidity);
    final windSpeed = state.weatherForecast.currentWeather.windSpeed.ceil();
    final windDirection = _getWindDirection(state.weatherForecast.currentWeather.windDeg);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kWhiteColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 88),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/images/wind.svg'),
                    const SizedBox(width: 8),
                    Text(
                      '$windSpeed м/с',
                      style: valueStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                  child: Text(
                'Ветер $windDirection',
                style: Theme.of(context).textTheme.titleMedium,
              )),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 88),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/images/drop.svg'),
                    const SizedBox(width: 8),
                    Text(
                      '$humidity%',
                      style: valueStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  humidityLevel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
