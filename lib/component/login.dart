library login_component;

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:duseapp/annotations.dart';

import 'package:duse/duse.dart';


@Component(
    selector: 'login',
    templateUrl: 'login.html')
class LoginComponent {
  String username;
  String password;
  DuseClient client;
  
  LoginComponent(@duseClient this.client);
  
  login() {
    if ([username, password].any(isEmpty)) {
      return window.alert("Username and/or password missing");
    }
    client.login(username, password);
  }
}


bool isEmpty(String string) {
  if (null == string || string.isEmpty) return true;
  return false;
}