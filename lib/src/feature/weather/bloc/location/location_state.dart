part of 'location_bloc.dart';

@immutable
abstract class LocationState {
  const LocationState();
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoadInProgress extends LocationState {
  const LocationLoadInProgress();
}

class LocationLoadSuccess extends LocationState {
  final Position position;

  const LocationLoadSuccess({required this.position});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationLoadSuccess && other.position == position;
  }

  @override
  int get hashCode => position.hashCode;
}

class LocationLoadFailure extends LocationState {
  final String message;
  final bool idLocationServiceEnabled;

  const LocationLoadFailure({
    required this.message,
    this.idLocationServiceEnabled = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LocationLoadFailure &&
      other.message == message &&
      other.idLocationServiceEnabled == idLocationServiceEnabled;
  }

  @override
  int get hashCode => message.hashCode ^ idLocationServiceEnabled.hashCode;
}
