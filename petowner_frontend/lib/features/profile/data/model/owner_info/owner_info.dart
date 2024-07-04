import 'package:equatable/equatable.dart';

import 'data.dart';

class OwnerInfo extends Equatable {
  final String? status;
  final String? message;
  final Data? data;

  const OwnerInfo({this.status, this.message, this.data});

  factory OwnerInfo.fromJson(Map<String, dynamic> json) => OwnerInfo(
        status: json['status'] as String?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };

  @override
  List<Object?> get props => [status, message, data];
}
