import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:restfulness/src/config/app_config.dart';
import 'package:restfulness/src/exceptions/app_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

 String baseUrl = AppConfig.instance.values.apiBaseUrl;

class ApiHelper {
  http.Client client = new http.Client();

  ApiHelper(){
    _readUrl().then((value) {
      if(value != ""){
        baseUrl = value;
      }
    });
  }

  Future<dynamic> get(String url, {Map<String, String> headers}) async {
    var responseJson;
    try {
      final response = await client.get('$baseUrl/$url', headers: headers);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException(createMessage("No Internet connection"));
    }
    return responseJson;
  }

  Future<dynamic> post(String url,
      {Map<String, String> headers, Map<String, dynamic> body}) async {
    var responseJson;
    try {
      final response = await client.post('$baseUrl/$url',
          headers: headers, body: jsonEncode(body));
      responseJson = _response(response);
    } on SocketException {

      throw FetchDataException(createMessage("No Internet connection"));
    }
    return responseJson;
  }

  Future<dynamic> delete(String url, {Map<String, String> headers}) async {
    var responseJson;
    try {
      final response = await client.delete('$baseUrl/$url', headers: headers);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException(createMessage("No Internet connection"));
    }
    return responseJson;
  }
}


dynamic _response(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var jsonData = json.decode(response.body);
      return jsonData;
    case 400:
      throw BadRequestException(response.body);
    case 401:
      throw UnauthorisedException(response.body);
    case 403:
      throw ForbiddenException(response.body);
    case 404:
      throw NotFoundException(response.body);
    case 500:
      throw InternalServerErrorException(response.body);
    default:
      throw FetchDataException(createMessage('Error code : ${response.statusCode}'));
  }
}

String createMessage(String message) {
  Map<String, dynamic> msg = new Map<String, dynamic>();
  msg["msg"] = message;
  return jsonEncode(msg);
}


Future<String> _readUrl() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'urlAddress';
  final value = prefs.getString(key) ?? '';
  return value;
}
