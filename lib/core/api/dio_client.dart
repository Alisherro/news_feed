import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../error/error.dart';
import 'dio_interceptor.dart';
import 'isolate_parser.dart';
import 'list_api.dart';

class DioClient {
  DioClient();

  Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: ListAPI.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        receiveTimeout: const Duration(minutes: 1),
        connectTimeout: const Duration(minutes: 1),
        validateStatus: (_) => true,
      ),
    )..interceptors.add(DioInterceptor());
  }

  late final _dio = _createDio();

  Future<Either<Exception, T>> getRequest<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic response) converter,
    bool isIsolate = true,
  }) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) > 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      if (!isIsolate) {
        return Right(converter(response.data));
      }
      final isolateParse = IsolateParser<T>(
        response.data as Map<String, dynamic>,
        converter,
      );
      final result = await isolateParse.parseInBackground();
      return Right(result);
    } on DioException catch (e, stackTrace) {
      Exception? exception;

      if (e.response?.statusCode == 401) {
        exception = const UnauthenticatedException();
      }
      String? errorMessage = e.message;
      return Left(
        exception ??
            ServerException(
              errorMessage,
            ),
      );
    }
  }
}
