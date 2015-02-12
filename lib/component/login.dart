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
  
  LoginComponent(@DuseClientConfig() this.client, this.router);
  
  login() {
    if ([username, password].any(isEmpty))
      return window.alert('Some entry is missing');
    
    client.login(username, password).then((token) {
      window.localStorage["token"] = token;
      router.go("user", {});
    }).catchError((e) => window.alert(e.toString()));
  }
}