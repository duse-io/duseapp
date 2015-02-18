library duseapp.component.login;

import 'dart:html';

import 'package:duseapp/global.dart';
import 'package:duseapp/component/load_button.dart';
import 'package:duseapp/component/main.dart';

import 'package:duse/duse.dart';
import 'package:angular/angular.dart';

@Component(
    selector: 'login',
    templateUrl: 'packages/duseapp/component/login.html',
    cssUrl: 'packages/duseapp/component/login.css',
    useShadowDom: false)
class LoginComponent {
  String username;
  String password;
  DuseClient client;
  Router router;
  MainComponent main;
  
  LoginComponent(@DuseClientConfig() this.client, this.router, this.main);
  
  login() {
    if ([username, password].any(isEmpty))
      return window.alert('Some entry is missing');
    
    var loginButton = ngDirectives("#loginButton")
                          .single as LoadButtonComponent;
    loginButton.isLoading = true;
    client.login(username, password).then((token) {
      main.fetchUser();
      window.localStorage["token"] = token;
      router.go("secrets.all", {});
    }).catchError((e) => window.alert(e.toString()))
    .whenComplete(() => loginButton.isLoading = false);
  }
}