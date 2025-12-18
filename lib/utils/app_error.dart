import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
abstract class AppError with _$AppError {
  const factory AppError.network(String message) = NetworkError;
  const factory AppError.server(String message) = ServerError;
  const factory AppError.validation(String message) = ValidationError;
  const factory AppError.unknown(String message) = UnknownError;
}

extension AppErrorExtension on AppError {
  String get message => when(
        network: (msg) => msg,
        server: (msg) => msg,
        validation: (msg) => msg,
        unknown: (msg) => msg,
      );
}

