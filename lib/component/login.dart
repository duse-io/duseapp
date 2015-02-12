library duseapp.component.login;

import 'dart:html';

import 'package:duseapp/global.dart';

import 'package:duse/duse.dart';
import 'package:angular/angular.dart';

@Component(
    selector: 'login',
    templateUrl: 'packages/duseapp/component/login.html',
    useShadowDom: false)
class LoginComponent {
  String username;
  String password;
  DuseClient client;
  Router router;
  bool isLoading = false;
  
  LoginComponent(@DuseClientConfig() this.client, this.router);
  
  @NgOneWay("button-text")
  String get buttonText => isLoading ? "Loading..." : "Login";
  
  login() {
    if ([username, password].any(isEmpty))
      return window.alert('Some entry is missing');
    
    isLoading = true;
    client.login(username, password).then((token) {
      window.localStorage["token"] = token;
      router.go("users.me", {});
    }).catchError((e) => window.alert(e.toString()))
    .whenComplete(() => isLoading = false);
  }
}