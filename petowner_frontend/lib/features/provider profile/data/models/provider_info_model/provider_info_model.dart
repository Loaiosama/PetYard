import 'package:equatable/equatable.dart';

import 'data.dart';

class ProviderInfoModel extends Equatable {
  final String? status;
  final Data? data;

  const ProviderInfoModel({this.status, this.data});

  factory ProviderInfoModel.fromJson(Map<String, dynamic> json) {
    return ProviderInfoModel(
      status: json['status'] as String?,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };

  @override
  List<Object?> get props => [status, data];
}
