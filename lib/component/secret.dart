library duseapp.component.secret;

import 'dart:html' show window;

import 'package:restpoint/restpoint.dart';
import 'package:duse/duse.dart';
import 'package:angular/angular.dart';

import 'package:duseapp/global.dart';

@Component(
    selector: 'secret',
    templateUrl: 'packages/duseapp/component/secret.html',
    useShadowDom: false)
class SecretComponent {
  Secret secret;
  
  DuseClient client;
  
  String password;
  String privatePem;
  
  SecretComponent(@DuseClientConfig() this.client,
                      RouteProvider routeProvider) {
    var id = int.parse(routeProvider.parameters["secretId"]);
    this.client.getSecret(id).then((entity) => secret = Secret.parse(entity));
  }
  
  void decrypt() {
    this.client.privateKey = this.privateKey;
    this.client.getDecodedSecret(secret.id).then((secret) {
      window.alert(secret);
    });
  }
  
  void reset() {
    window.localStorage.remove("private_key");
  }
  
  String get privateKey {
    if (!isPrivateKeyPresent) {
      encryptAndStore("private_key", password, privatePem);
      return privatePem;
    }
    return retrieveAndDecrypt("private_key", password);
  }
  
  bool get isPrivateKeyPresent {
    return window.localStorage.containsKey("private_key");
  }
}

class Secret {
  int id;
  String title;
  List<User> users;
  
  Secret(this.id, this.title, this.users);
  
  static Secret parse(Entity entity) {
    return new Secret(entity.id,
                      entity.title,
                      entity.users.map(User.parse).toList());
  }
}

class User {
  int id;
  String username;
  
  User(this.id, this.username);
  
  static User parse(Entity entity) => new User(entity.id, entity.username);
}