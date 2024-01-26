// login
class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

class UserDisabledException implements Exception {}

// register
class UserAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
