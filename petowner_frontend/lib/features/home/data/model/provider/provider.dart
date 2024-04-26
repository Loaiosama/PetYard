import 'package:equatable/equatable.dart';

import 'datum.dart';

class Provider extends Equatable {
  final String? status;
  final String? message;
  final List<Datum>? data;

  const Provider({this.status, this.message, this.data});

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        status: json['status'] as String?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [status, message, data];
}
