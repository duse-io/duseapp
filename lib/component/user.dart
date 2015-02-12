library duseapp.component.user;

import 'dart:html';

import 'package:duseapp/global.dart';

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';
import 'package:restpoint/restpoint.dart';


@Component(
    selector: 'user',
    templateUrl: 'packages/duseapp/component/user.html',
    useShadowDom: false)
class UserComponent {
  List<Secret> secrets;
  
  Router router;
  
  DuseClient client;
  User user;
  
  
  UserComponent(@DuseClientConfig() this.client) {
    _load();
  }
  
  _load() {
    _loadUser();
    _loadSecrets();
  }
  
  _loadSecrets() =>
      this.client.listSecrets().then((ents) =>
          secrets = ents.map(Secret.parse).toList());
  
  _loadUser() =>
      this.client.getCurrentUser().then((ent) => user = User.parse(ent));
}

class User {
  String username;
  String email;
  
  User(this.username, this.email);
  
  static User parse(Entity user) {
    return new User(user.username, user.email);
  }
}


class Secret {
  String title;
  
  Secret(this.title);
  
  static Secret parse(Entity secret) {
    return new Secret(secret.title);
  }
}