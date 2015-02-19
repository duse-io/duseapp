library duseapp.component.user;

import 'dart:async' show Future;

import 'package:duseapp/global.dart';
import 'package:duseapp/model/alert.dart';

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';


@Component(
    selector: 'secret-list',
    templateUrl: 'packages/duseapp/component/secret_list.html',
    cssUrl: 'packages/duseapp/component/secret_list.css',
    useShadowDom: false)
class SecretListComponent implements ScopeAware {
  List<Secret> secrets;
  
  Router router;
  
  DuseClient client;
  User user;
  String titleFilter = "";
  Scope scope;
  
  
  SecretListComponent(@DuseClientConfig() this.client) {
    _load();
  }
  
  _load() {
    if (scope != null) scope.emit("load", true);
    Future.wait([_loadUser(), _loadSecrets()])
          .catchError((e) =>
              scope.emit("alert", new Alert.danger("Could not load secret list")))
          .whenComplete(() {
            if (scope != null)
              scope.emit("load", false);
          });
  }
  
  _loadSecrets() =>
      this.client.listSecrets().then((ents) =>
          secrets = ents.map(Secret.parse).toList());
  
  _loadUser() =>
      this.client.getCurrentUser().then((ent) => user = User.parse(ent));
  
  deleteSecret(Secret secret) {
    scope.emit("load", true);
    this.client.deleteSecret(secret.id).then((_) {
      this.secrets.remove(secret);
    }).catchError((e) {
      scope.emit("alert", new Alert.warning("Could not delete secret"));
    }).whenComplete(() => scope.emit("load", false));
  }
}