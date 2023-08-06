import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'location_event.dart';
part 'location_state.dart';

/// Блок для работы с геолокацией
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(const LocationInitial()) {
    on<LocationStarted>((event, emit) async {
      emit(const LocationLoadInProgress());

      if (!await Geolocator.isLocationServiceEnabled()) {
        return emit(const LocationLoadFailure(
          message: 'Необходимо включить геолокацию на устройстве',
        ));
      }

      if (!await Permission.location.request().isGranted) {
        return emit(const LocationLoadFailure(
          message: 'Необходимо предоставить разрешение для определения местоположения',
        ));
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          forceAndroidLocationManager: true,
          timeLimit: const Duration(seconds: 5),
        );
      } catch (e) {
        position = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
      }
      if (position == null) {
        return emit(const LocationLoadFailure(
          message: 'Не удалось определить местоположение',
        ));
      }
      add(LocationChanged(position: position));
    });
    on<LocationChanged>((event, emit) {
      emit(LocationLoadSuccess(position: event.position));
    });
  }
}
