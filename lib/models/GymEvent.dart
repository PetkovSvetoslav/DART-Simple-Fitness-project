enum GymEventType {
  register,
  assignCard,
  login,
  logout,
  occupyLocker,
  releaseLocker,
}

class GymEvent {
  final DateTime time;
  final GymEventType type;
  final int personId;
  final int? lockerNumber;
  final String message;

  GymEvent({
    required this.time,
    required this.type,
    required this.personId,
    this.lockerNumber,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
    'time': time.toIso8601String(),
    'type': type.name,
    'personId': personId,
    'lockerNumber': lockerNumber,
    'message': message,
  };

  static GymEvent fromJson(Map<String, dynamic> json) => GymEvent(
    time: DateTime.parse(json['time'] as String),
    type: GymEventType.values.byName(json['type'] as String),
    personId: json['personId'] as int,
    lockerNumber: json['lockerNumber'] as int?,
    message: json['message'] as String,
  );
}

