/// Custom exception for clean user-facing error messages.
/// Ensures stack traces, SQL, file paths, or raw exceptions are never presented to the user.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
