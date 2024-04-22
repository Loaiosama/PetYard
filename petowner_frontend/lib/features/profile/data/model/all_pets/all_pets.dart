import 'package:equatable/equatable.dart';

import 'datum.dart';

class AllPetsModel extends Equatable {
  final String? status;
  final String? message;
  final List<Datum>? data;

  const AllPetsModel({this.status, this.message, this.data});

  factory AllPetsModel.fromJson(Map<String, dynamic> json) => AllPetsModel(
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
