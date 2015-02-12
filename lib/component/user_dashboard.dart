library duseapp.component.user;

import 'dart:html';

import 'package:duseapp/global.dart';

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';
import 'package:restpoint/restpoint.dart';


@Component(
    selector: 'user-dashboard',
    templateUrl: 'packages/duseapp/component/user_dashboard.html',
    useShadowDom: false)
class UserDashboardComponent {
  List<Secret> secrets;
  
  Router router;
  
  DuseClient client;
  User user;
  
  
  UserDashboardComponent(@DuseClientConfig() this.client) {
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
  int id;
  String title;
  
  Secret(this.id, this.title);
  
  static Secret parse(Entity secret) {
    return new Secret(secret.id, secret.title);
  }
}