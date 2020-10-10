import 'dart:convert';

class SignUpModel {

  String msg;
  String username;

  SignUpModel.fromJson(Map<String ,dynamic> parsedJson){
    msg = parsedJson['msg'] ;
    username = parsedJson['username'] ;
  }

}