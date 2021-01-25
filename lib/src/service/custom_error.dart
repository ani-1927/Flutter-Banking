import 'dart:core';

/* This is a CustomError which is used to handle to api response.*/
class CustomError implements Exception {
  final String message;

  CustomError(this.message);

  String toString() {
    return this.message;
  }
}
