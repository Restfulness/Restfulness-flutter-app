import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:restfulness/src/exceptions/app_exceptions.dart';

class ApiHelper {
  http.Client client = new http.Client();

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<dynamic> post(String url,{Map<String, String> headers, Map<String, String>  body} ) async {
    var responseJson;
    try {
      final response = await client.post(url, headers: headers, body: jsonEncode(body));
      responseJson =  _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
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
      throw FetchDataException('Error code : ${response.statusCode}');
  }
}
