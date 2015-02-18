library duseapp.component.main;

import 'dart:html' show window;

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

import 'package:duseapp/global.dart';

@Component(
    selector: 'main',
    templateUrl: 'packages/duseapp/component/main.html',
    useShadowDom: false)
class MainComponent implements ScopeAware, AttachAware {
  User user;
  
  DuseClient client;
    
  MainComponent(@DuseClientConfig() this.client);
  
  void set scope(Scope scope) {
    scope.on("login").listen((event) {
      if (null == user) fetchUser();
    });
  }
  
  void attach() {
    if (client.isLoggedIn) fetchUser();
  }
  
  void fetchUser() {
    client.getCurrentUser().then((ent) {
      user = User.parse(ent);
    });
  }
  
  void logout() {
    window.localStorage.remove("token");
    this.user = null;
    //this.client.logout();
  }
  
  bool get isLoggedIn => user != null;
}