import 'package:dio/dio.dart';

/// Http Service Interface
abstract class HttpService {
  /// Http get request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool forceRefresh = false,
    HttpServiceResponseType httpServiceResponseType =
        HttpServiceResponseType.none,
  });

  /// Http post request
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Object? data,
  });

  /// Http put request
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Object? data,
  });

  /// Http delete request
  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  });
}

/// Enum representing different types of HTTP service response.
enum HttpServiceResponseType {
  /// Response type is JSON data.
  json,

  /// Response type is a stream.
  stream,

  /// Response type is raw bytes.
  bytes,

  /// Response type is plain text.
  plain,

  /// Response type is text.
  text,

  /// No specific response type.
  none;

  ///
  ResponseType responseTypeMapping() {
    switch (this) {
      case HttpServiceResponseType.json:
        return ResponseType.json;
      case HttpServiceResponseType.stream:
        return ResponseType.stream;
      case HttpServiceResponseType.bytes:
        return ResponseType.bytes;
      case HttpServiceResponseType.plain:
        return ResponseType.plain;
      case HttpServiceResponseType.text:
        return ResponseType.plain;
      case HttpServiceResponseType.none:
        return ResponseType.plain;
    }
  }
}
