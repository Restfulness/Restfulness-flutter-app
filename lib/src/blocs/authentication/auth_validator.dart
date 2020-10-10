import 'dart:async';

class AuthValidator {
  final validUsername = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) {
    if (username.length > 3) {
      sink.add(username);
    } else {
      sink.addError("Username must be at least 4 character");
    }
  });

  final validPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 3) {
      sink.add(password);
    } else {
      sink.addError("Password must be at least 4 character");
    }
  });
}
