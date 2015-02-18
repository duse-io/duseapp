library duseapp.component.login;

import 'dart:html';

import 'package:duseapp/global.dart';
import 'package:duseapp/component/load_button.dart';

import 'package:duse/duse.dart';
import 'package:angular/angular.dart';

@Component(
    selector: 'login',
    templateUrl: 'packages/duseapp/component/login.html',
    cssUrl: 'packages/duseapp/component/login.css',
    useShadowDom: false)
class LoginComponent implements ScopeAware, AttachAware {
  String username;
  String password;
  DuseClient client;
  Router router;
  Scope scope;
  
  LoginComponent(@DuseClientConfig() this.client, this.router);
  
  login() {
    if ([username, password].any(isEmpty))
      return window.alert('Some entry is missing');
    
    var loginButton = ngDirectives("#loginButton")
                          .single as LoadButtonComponent;
    loginButton.isLoading = true;
    client.login(username, password).then((token) {
      scope.emit("login");
      window.localStorage["token"] = token;
      router.go("secrets.all", {});
    }).catchError((e) => window.alert(e.toString()))
    .whenComplete(() => loginButton.isLoading = false);
  }
  
  void attach() {
    //if (this.client.isLoggedIn) router.go("secrets", {});
  }
}