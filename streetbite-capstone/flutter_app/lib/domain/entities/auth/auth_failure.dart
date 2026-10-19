class AuthFailure implements Exception {
  final String messageKey;
  const AuthFailure(this.messageKey);
}
