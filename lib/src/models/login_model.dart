

class LoginModel {

  String accessToken;


  LoginModel.fromJson(Map<String ,dynamic> parsedJson){
    accessToken = parsedJson['access_token'] ;
  }

  LoginModel.fromDB(Map<String ,dynamic> parsedJson){
    accessToken = parsedJson['access_token'] ;
  }

  Map<String , dynamic> toMap(){
    return {
      "accessToken": accessToken,
    };
  }
}


