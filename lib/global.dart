library duseapp.global;

import 'package:restpoint/restpoint.dart';

import 'package:duseapp/crypto/crypto.dart';

class DuseClientConfig {
  const DuseClientConfig();
}

bool isEmpty(String string) {
  if (null == string || string.isEmpty) return true;
  return false;
}

class Secret {
  int id;
  String title;
  List<User> users;
  
  Secret(this.id, this.title, this.users);
  
  static Secret parse(Entity entity) {
    var users = entity.get("users");
    if (null != users) users = users.map(User.parse).toList();
    return new Secret(entity.id,
                      entity.title,
                      users);
  }
}

class User {
  int id;
  String username;
  String email;
  String gravatarUrl;
  
  User(this.id, this.username, this.email) {
    gravatarUrl = "http://www.gravatar.com/avatar/${buildGravatarHash(email)}";
  }
  
  String sizedGravatarUrl(int size) {
    if (size < 1 || size > 2048) throw new RangeError.range(size, 1, 2048);
    return "$gravatarUrl?s=$size";
  }
  
  static User parse(Entity entity) =>
      new User(entity.id, entity.username, entity.email);
}