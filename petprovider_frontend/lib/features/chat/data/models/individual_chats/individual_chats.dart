import 'package:equatable/equatable.dart';

import 'indiv_datum.dart';

class IndividualChats extends Equatable {
  final String? status;
  final List<IndividualDatum>? data;

  const IndividualChats({this.status, this.data});

  factory IndividualChats.fromJson(Map<String, dynamic> json) {
    return IndividualChats(
      status: json['Status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => IndividualDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'Status': status,
        'data': data?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [status, data];
}
