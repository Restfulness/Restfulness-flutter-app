import 'dart:async';

class AuthValidator {
  final validEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink) {
        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if (emailValid) {
      sink.add(email);
    } else {
      sink.addError("Enter valid email");
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
