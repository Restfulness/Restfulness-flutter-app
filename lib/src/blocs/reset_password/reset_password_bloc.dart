import 'dart:convert';

import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:rxdart/rxdart.dart';

class ResetPasswordBloc {
  final _repository = new Repository();
  final _forgetPass = BehaviorSubject<String>();
  final _verifyCode = BehaviorSubject<String>();
  final _resetPass = BehaviorSubject<String>();

  // Stream
  Observable<String> get forgot => _forgetPass.stream;

  Observable<String> get code => _verifyCode.stream;

  Observable<String> get reset => _resetPass.stream;

  forgotPass(String email) async {
    try {
      final res = await _repository.forgotPass(email);
      _forgetPass.sink.add(res);
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        _forgetPass.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _forgetPass.sink.addError("Unexpected server error");
      }
    }
  }

  verifyCode(String hash, int code) async {
    try {
      final res = await _repository.verifyCode(hash, code);
      _verifyCode.sink.add(res);
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        _verifyCode.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _verifyCode.sink.addError("Unexpected server error");
      }
    }
  }

  resetPass(String token, String newPass) async {
    try {
      final res = await _repository.resetPass(token, newPass);
      _resetPass.sink.add(res);
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        _resetPass.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _resetPass.sink.addError("Unexpected server error");
      }
    }
  }

  resetForgetPassStream() {
    _forgetPass.add('');
  }

  resetVerifyCodeStream() {
    _verifyCode.add('');
  }

  resetResetPassStream() {
    _resetPass.add('');
  }

  resetFVR() {
    _forgetPass.add('');
    _verifyCode.add('');
    _resetPass.add('');
  }

  dispose() {
    _forgetPass.close();
    _verifyCode.close();
    _resetPass.close();
  }
}
