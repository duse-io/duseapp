library duseapp.component.register;

import 'dart:html';

import 'package:duseapp/global.dart';

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

@Component(
    selector: 'register',
    templateUrl: 'packages/duseapp/component/register.html',
    useShadowDom: false)
class RegisterComponent {
  String username;
  String email;
  String password;
  String passwordRepetition;
  String publickey;
  
  DuseClient client;
  
  RegisterComponent(@DuseClientConfig() this.client);
  
  register() {
    if ([username, email, password, publickey, passwordRepetition].any(isEmpty))
      return window.alert('Some entry is missing');
    if (password != passwordRepetition)
      return window.alert('Password needs to be the same as repetition');
    
    client.createUser(username, password, email, publickey).then((ent) {
      window.alert(ent.toString());
    }).catchError((e) =>
        window.alert(e.toString()));
  }
}