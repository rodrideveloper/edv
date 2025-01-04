class AuthResult {
  AuthResult._();
  factory AuthResult.success() => AuthResultSuccess();
  factory AuthResult.error(String? message) => AuthResultError(message);
}

class AuthResultSuccess extends AuthResult {
  AuthResultSuccess() : super._();
}

class AuthResultError extends AuthResult {
  String? message;
  AuthResultError(this.message) : super._();
}
