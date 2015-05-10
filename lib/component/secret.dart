library duseapp.component.secret;

import 'dart:html' show window;

import 'package:duse/duse.dart';
import 'package:angular/angular.dart';

import 'package:duseapp/global.dart';
import 'package:duseapp/crypto/crypto.dart';

@Component(
    selector: 'secret',
    templateUrl: 'packages/duseapp/component/secret.html',
    useShadowDom: false)
class SecretComponent implements AttachAware, ScopeAware {
  Secret secret;
  
  DuseClient client;
  Scope scope;
  
  String password;
  String privatePem;
  RouteProvider routeProvider;
  
  SecretComponent(@DuseClientConfig() this.client, this.routeProvider);
  
  void attach() {
    var id = int.parse(routeProvider.parameters["secretId"]);
    this.client.getSecret(id).then((entity) => secret = Secret.parse(entity));
  }
  
  void decrypt() {
    this.client.privateKey = this.privateKey;
    scope.emit("load", true);
    this.client.getDecodedSecret(secret.id).then((secret) {
      window.alert(secret);
    }).whenComplete(() => scope.emit("load", false));
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