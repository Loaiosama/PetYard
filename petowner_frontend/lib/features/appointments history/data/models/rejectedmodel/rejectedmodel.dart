import 'package:equatable/equatable.dart';

import 'rejected_datum.dart';

class Rejectedmodel extends Equatable {
  final String? status;
  final String? message;
  final List<RejectedDatum>? data;

  const Rejectedmodel({this.status, this.message, this.data});

  factory Rejectedmodel.fromJson(Map<String, dynamic> json) => Rejectedmodel(
        status: json['status'] as String?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => RejectedDatum.fromJson(e as Map<String, dynamic>))
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
