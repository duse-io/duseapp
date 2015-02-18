library duseapp.component.user;

import 'dart:html' show window;

import 'package:duseapp/global.dart';

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';


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
  int id;
  
  
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
  
  selectSecret(int id) {
    this.id = id;
  }
  
  deleteSecret() {
    this.client.deleteSecret(id).then((_) {
      this.secrets.removeWhere((secret) => secret.id == id);
    }).catchError((e) => window.alert(e));
  }
}