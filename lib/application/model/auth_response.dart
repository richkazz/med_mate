// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

@immutable
class ApiResponse {
  final int responseCode;
  final String? message;
  final DateTime timeStamp;
  final bool successful;
  final dynamic response;
  final dynamic medication;
  const ApiResponse({
    required this.responseCode,
    required this.timeStamp,
    required this.successful,
    this.message,
    this.response,
    this.medication,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      responseCode: map['responseCode'] as int,
      message: map['message'] != null ? map['message'] as String : null,
      timeStamp: DateTime.parse(map['timeStamp'] as String),
      successful: map['successful'] as bool,
      response: map['response'] as dynamic,
      medication: map['medication'] as dynamic,
    );
  }
  @override
  String toString() {
    return 'ApiResponse(responseCode: $responseCode, message: $message, timeStamp: $timeStamp, successful: $successful)';
  }
}
