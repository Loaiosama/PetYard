class BoardingReservation {
  final int reserveId;
  final int slotId;
  final int petId;
  final int ownerId;
  final DateTime startTime;
  final DateTime endTime;
  final String expirationTime;
  final double finalPrice;
  final String type;
  final DateTime slotStartTime;
  final DateTime slotEndTime;

  BoardingReservation({
    required this.reserveId,
    required this.slotId,
    required this.petId,
    required this.ownerId,
    required this.startTime,
    required this.endTime,
    required this.expirationTime,
    required this.finalPrice,
    required this.type,
    required this.slotStartTime,
    required this.slotEndTime,
  });

  factory BoardingReservation.fromJson(Map<String, dynamic> json) {
    return BoardingReservation(
      reserveId: json['reserve_id'],
      slotId: json['slot_id'],
      petId: json['pet_id'],
      ownerId: json['owner_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      expirationTime: json['expirationtime'],
      finalPrice: (json['final_price'] as num).toDouble(),
      type: json['type'],
      slotStartTime: DateTime.parse(json['slot_start_time']),
      slotEndTime: DateTime.parse(json['slot_end_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reserve_id': reserveId,
      'slot_id': slotId,
      'pet_id': petId,
      'owner_id': ownerId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'expirationtime': expirationTime,
      'final_price': finalPrice,
      'type': type,
      'slot_start_time': slotStartTime.toIso8601String(),
      'slot_end_time': slotEndTime.toIso8601String(),
    };
  }
}
