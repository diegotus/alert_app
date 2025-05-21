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
    : super(message, "Erreur lors de la communication:");
}

class BadRequestException extends AppException {
  BadRequestException([message])
    : super(message, "Requête non valide. Réessayer.");
}

class UnknownException extends AppException {
  UnknownException([message]) : super(message, "Exception inconnue. ");
}

class UnauthorisedException<T> extends AppException {
  UnauthorisedException([message])
    : super(message, "Requête non autorisée. Veuillez réessayer.. ");
  UnauthorisedException.userNotLogin()
    : super("L'utilisateur n'est pas connecté ou la session a expiré.", 0);
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
    : super(message, "Entrée non valide. Réessayer. ");
}
