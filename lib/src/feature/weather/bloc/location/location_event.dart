part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {
  const LocationEvent();
}

class LocationStarted extends LocationEvent {
  const LocationStarted();
}

class LocationChanged extends LocationEvent {
  final Position position;

  const LocationChanged({required this.position});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LocationChanged &&
      other.position == position;
  }

  @override
  int get hashCode => position.hashCode;
}
