import 'package:equatable/equatable.dart';

import 'data.dart';

class ProviderInfoModel extends Equatable {
  final String? status;
  final Data? data; // Changed from 'data' to 'provider'
  final List<Service>? services; // Added services field

  const ProviderInfoModel({this.status, this.data, this.services});

  factory ProviderInfoModel.fromJson(Map<String, dynamic> json) {
    return ProviderInfoModel(
      status: json['status'] as String?,
      data: json['provider'] != null
          ? Data.fromJson(json['provider'] as Map<String, dynamic>)
          : null,
      services: json['services'] != null
          ? (json['services'] as List)
              .map((service) =>
                  Service.fromJson(service as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'provider': data?.toJson(),
        'services': services?.map((service) => service.toJson()).toList(),
      };

  @override
  List<Object?> get props => [status, data, services];
}
