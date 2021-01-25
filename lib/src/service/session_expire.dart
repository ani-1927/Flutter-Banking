import 'dart:core';

/* This is the custom exception used to maintain the application session*/
class SessionExpire implements Exception {
  final String message;

  SessionExpire(this.message);

  String toString() {
    return this.message;
  }
}
