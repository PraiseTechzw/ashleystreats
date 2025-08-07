import 'package:flutter/foundation.dart';

// Base app error class
abstract class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppError({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    if (kDebugMode) {
      return 'AppError: $message${code != null ? ' (Code: $code)' : ''}';
    }
    return message;
  }
}

// Generic app error implementation
class GenericAppError extends AppError {
  const GenericAppError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// Authentication errors
class AuthError extends AppError {
  const AuthError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// Network errors
class NetworkError extends AppError {
  const NetworkError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// Database errors
class DatabaseError extends AppError {
  const DatabaseError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// Validation errors
class ValidationError extends AppError {
  final Map<String, String>? fieldErrors;

  const ValidationError({
    required super.message,
    super.code,
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });
}

// Business logic errors
class BusinessError extends AppError {
  const BusinessError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// Storage errors
class StorageError extends AppError {
  const StorageError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// Permission errors
class PermissionError extends AppError {
  const PermissionError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// Error handler utility
class ErrorHandler {
  static AppError handleError(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppError) {
      return error;
    }

    // Firebase Auth errors
    if (error.toString().contains('firebase_auth')) {
      return AuthError(
        message: _getFirebaseAuthErrorMessage(error.toString()),
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Network errors
    if (error.toString().contains('SocketException') ||
        error.toString().contains('HandshakeException') ||
        error.toString().contains('TimeoutException')) {
      return NetworkError(
        message: 'Network connection failed. Please check your internet connection.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Database errors
    if (error.toString().contains('DatabaseException') ||
        error.toString().contains('isar')) {
      return DatabaseError(
        message: 'Database operation failed. Please try again.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Generic error
    return GenericAppError(
      message: kDebugMode ? error.toString() : 'An unexpected error occurred.',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  static String _getFirebaseAuthErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No account found with this email address.';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (error.contains('email-already-in-use')) {
      return 'An account with this email already exists.';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak. Please choose a stronger password.';
    } else if (error.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else if (error.contains('user-disabled')) {
      return 'This account has been disabled.';
    } else if (error.contains('too-many-requests')) {
      return 'Too many failed attempts. Please try again later.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    }
    return 'Authentication failed. Please try again.';
  }

  static void logError(AppError error) {
    if (kDebugMode) {
      print('Error: ${error.message}');
      if (error.code != null) print('Code: ${error.code}');
      if (error.originalError != null) print('Original: ${error.originalError}');
      if (error.stackTrace != null) print('Stack: ${error.stackTrace}');
    }
    // In production, you might want to send errors to a logging service
    // like Firebase Crashlytics, Sentry, etc.
  }
}

// Result wrapper for operations that can fail
class Result<T> {
  final T? data;
  final AppError? error;

  const Result.success(this.data) : error = null;
  const Result.failure(this.error) : data = null;

  bool get isSuccess => error == null && data != null;
  bool get isFailure => error != null;

  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) failure,
  }) {
    if (isSuccess) {
      return success(data as T);
    } else {
      return failure(error!);
    }
  }
}