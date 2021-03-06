library duseapp.component.register;

import 'dart:html';

import 'package:duseapp/global.dart';
import 'package:duseapp/model/alert.dart';

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

@Component(
    selector: 'register',
    templateUrl: 'packages/duseapp/component/register.html',
    useShadowDom: false)
class RegisterComponent implements ScopeAware {
  String username;
  String email;
  String password;
  String passwordRepetition;
  String publickey;
  
  DuseClient client;
  Router router;
  Scope scope;
  
  RegisterComponent(@DuseClientConfig() this.client, this.router);
  
  register() {
    if ([username, email, password, publickey, passwordRepetition].any(isEmpty))
      return window.alert('Some entry is missing');
    if (password != passwordRepetition)
      return window.alert('Password needs to be the same as repetition');
    
    scope.emit("load", true);
    client.createUser(username, password, email, publickey).then((ent) {
      router.go("postregister", {});
    }).catchError((e) =>
        scope.emit("alert", new Alert.warning("Could not register"))
    ).whenComplete(() => scope.emit("load", false));
  }
}