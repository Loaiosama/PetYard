import 'package:equatable/equatable.dart';

import 'pended_datum.dart';

class Pendingmodel extends Equatable {
  final String? status;
  final String? message;
  final List<PendedDatum>? data;

  const Pendingmodel({this.status, this.message, this.data});

  factory Pendingmodel.fromJson(Map<String, dynamic> json) => Pendingmodel(
        status: json['status'] as String?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => PendedDatum.fromJson(e as Map<String, dynamic>))
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
