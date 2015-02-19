library duseapp.component.login;

import 'dart:html';

import 'package:duseapp/global.dart';
import 'package:duseapp/component/main.dart';
import 'package:duseapp/model/alert.dart';

import 'package:duse/duse.dart';
import 'package:angular/angular.dart';

@Component(
    selector: 'login',
    templateUrl: 'packages/duseapp/component/login.html',
    cssUrl: 'packages/duseapp/component/login.css',
    useShadowDom: false)
class LoginComponent implements ScopeAware {
  String username;
  String password;
  DuseClient client;
  Router router;
  MainComponent main;
  
  Scope scope;
  
  LoginComponent(@DuseClientConfig() this.client, this.router, this.main);
  
  login() {
    if ([username, password].any(isEmpty))
      return window.alert('Some entry is missing');
    
    scope.emit("load", true);
    client.login(username, password).then((token) {
      main.fetchUser();
      window.localStorage["token"] = token;
      router.go("secrets.all", {});
    }).catchError((e) {
      scope.emit("alert", new Alert.danger("Username or Password not correct"));
    }).whenComplete(() => scope.emit("load", false));
  }
}