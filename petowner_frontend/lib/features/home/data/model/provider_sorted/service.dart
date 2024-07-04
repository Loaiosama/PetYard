import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final int? serviceId;
  final int? providerId;
  final String? type;

  const Service({this.serviceId, this.providerId, this.type});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
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
