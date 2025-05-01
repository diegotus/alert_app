class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  getMessage() {
    return _message;
  }

  getPrefix() {
    return _prefix;
  }

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message])
      : super(message, "Invalid Request. Try again. ");
}

class UnknownException extends AppException {
  UnknownException([message]) : super(message, "Unknown Exception. ");
}

class UnauthorisedException<T> extends AppException {
  UnauthorisedException([message])
      : super(message, "Unauthorised request. Try again. ");
  UnauthorisedException.userNotLogin()
      : super("User Not Login or session expired.", 0);
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message, "Invalid Input. Try again. ");
}
