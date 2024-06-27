import 'package:equatable/equatable.dart';

import 'datum.dart';
import 'providerinfo.dart';

class ProfileInfo extends Equatable {
  final String? status;
  final String? message;
  final List<Providerinfo>? providerinfo;
  final List<Datum>? data;

  const ProfileInfo({
    this.status,
    this.message,
    this.providerinfo,
    this.data,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) => ProfileInfo(
        status: json['status'] as String?,
        message: json['message'] as String?,
        providerinfo: (json['providerinfo'] as List<dynamic>?)
            ?.map((e) => Providerinfo.fromJson(e as Map<String, dynamic>))
            .toList(),
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'providerinfo': providerinfo?.map((e) => e.toJson()).toList(),
        'data': data?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [status, message, providerinfo, data];
}
