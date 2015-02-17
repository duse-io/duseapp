library duseapp.component.user;

import 'dart:html' show window;

import 'package:duseapp/global.dart';

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';
import 'package:restpoint/restpoint.dart';


@Component(
    selector: 'secret-list',
    templateUrl: 'packages/duseapp/component/secret_list.html',
    cssUrl: 'packages/duseapp/component/secret_list.css',
    useShadowDom: false)
class SecretListComponent {
  List<Secret> secrets;
  
  Router router;
  
  DuseClient client;
  User user;
  String titleFilter = "";
  
  
  SecretListComponent(@DuseClientConfig() this.client) {
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
  
  deleteSecret(id) {
    this.client.deleteSecret(id).then((_) {
      this.secrets.removeWhere((secret) => secret.id == id);
      window.alert("Deleted secret $id");
    }).catchError((e) => window.alert(e));
  }
}

class User {
  int id;
  String username;
  String email;
  
  User(this.id, this.username, this.email);
  
  static User parse(Entity user) {
    return new User(user.id, user.username, user.email);
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