library duseapp.global;

import 'package:restpoint/restpoint.dart';

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
  
  User(this.id, this.username, this.email);
  
  static User parse(Entity entity) =>
      new User(entity.id, entity.username, entity.email);
}