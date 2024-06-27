import 'package:equatable/equatable.dart';

class Datum extends Equatable {
  final int? serviceId;
  final int? providerId;
  final String? type;

  const Datum({this.serviceId, this.providerId, this.type});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        serviceId: json['service_id'] as int?,
        providerId: json['provider_id'] as int?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'service_id': serviceId,
        'provider_id': providerId,
        'type': type,
      };

  @override
  List<Object?> get props => [serviceId, providerId, type];
}
