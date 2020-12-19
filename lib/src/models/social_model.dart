class SocialModel {
  String lastUpdate;
  int totalLinks;
  int userId;
  String username;

  SocialModel.fromJson(Map<String, dynamic> parsedJson) {
    lastUpdate = parsedJson['last_link_added_date'];
    totalLinks = parsedJson['total_links_added_after_given_time'];
    userId = parsedJson['user_id'];
    username = parsedJson['username'];

  }

}
