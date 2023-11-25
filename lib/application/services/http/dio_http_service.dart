// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:med_mate/application/services/http/http_service.dart';
import 'package:med_mate/application/services/network_info.dart';

/// Http service implementation using the Dio package
///
/// See https://pub.dev/packages/dio
class DioHttpService implements HttpService {
  /// Creates new instance of [DioHttpService]
  DioHttpService({
    required NetworkInfoImpl networkInfo,
    required String baseUrl,
    required Map<String, String> headers,
    Dio? dioOverride,
    bool enableCaching = false,
  }) : _networkInfo = networkInfo {
    dio = dioOverride ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: headers,
          ),
        );

    if (enableCaching) {
      //dio.interceptors.add(CacheInterceptor());
    }
  }
  final NetworkInfoImpl _networkInfo;

  /// The Dio Http client
  late final Dio dio;

  @override
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool forceRefresh = false,
    String? customBaseUrl,
    HttpServiceResponseType httpServiceResponseType =
        HttpServiceResponseType.none,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        throw NetWorkFailure();
      }
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: HttpServiceResponseType.none == httpServiceResponseType
            ? null
            : Options(
                responseType: httpServiceResponseType.responseTypeMapping(),
              ),
      );
      if (response.data == null || response.statusCode != 200) {
        throw HttpException(
          title: 'Http Error!',
          statusCode: response.statusCode,
          message: response.statusMessage,
        );
      }

      return response.data;
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 401) {
        throw Error.throwWithStackTrace(AuthenticationException(), stackTrace);
      }
      throw Error.throwWithStackTrace(error, stackTrace);
    } catch (error, stackTrace) {
      throw Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Future<dynamic> post(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetWorkFailure();
    }
    //dio.options.headers = headers;
    final response =
        await dio.post(endpoint, data: data, queryParameters: queryParameters);

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw HttpException(
        title: 'Http Error!',
        statusCode: response.statusCode,
        message: response.statusMessage,
      );
    }

    return response.data;
  }

  @override
  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetWorkFailure();
    }
    //dio.options.headers = Api.headers;
    final response =
        await dio.delete(endpoint, queryParameters: queryParameters);
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw HttpException(
        title: 'Http Error!',
        statusCode: response.statusCode,
        message: response.statusMessage,
      );
    }
    return response.data;
  }

  @override
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetWorkFailure();
    }
    final response =
        await dio.put(endpoint, queryParameters: queryParameters, data: data);

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw HttpException(
        title: 'Http Error!',
        statusCode: response.statusCode,
        message: response.statusMessage,
      );
    }

    return response.data;
  }
}
