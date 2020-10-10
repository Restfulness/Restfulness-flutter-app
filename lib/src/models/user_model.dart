class UserModel {
  int id = 1;
  String username;
  String password;
  String accessToken;

  UserModel.fromJson(Map<String ,dynamic> parsedJson){
    username = parsedJson['username'];
    password = parsedJson['password'];
    accessToken = parsedJson['accessToken'];
  }

  UserModel.fromDB(Map<String, dynamic> parsedJson) {
    username = parsedJson['username'];
    password = parsedJson['password'];
    accessToken = parsedJson['accessToken'];
  }

  Map<String , dynamic> toMap(){
    return {
      'id' : id,
      'username':username,
      'password': password,
      'accessToken': accessToken,
    };
  }
}
