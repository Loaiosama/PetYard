import 'package:equatable/equatable.dart';

import 'accepted_datum.dart';

class Acceptedmodel extends Equatable {
  final String? status;
  final String? message;
  final List<AcceptedDatum>? data;

  const Acceptedmodel({this.status, this.message, this.data});

  factory Acceptedmodel.fromJson(Map<String, dynamic> json) => Acceptedmodel(
        status: json['status'] as String?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => AcceptedDatum.fromJson(e as Map<String, dynamic>))
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
