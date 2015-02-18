library duseapp.component.main;

import 'dart:html' show window;

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

import 'package:duseapp/global.dart';

@Component(
    selector: 'main',
    templateUrl: 'packages/duseapp/component/main.html',
    useShadowDom: false)
class MainComponent implements AttachAware {
  User user;
  
  DuseClient client;
  
  RouteProvider provider;
    
  MainComponent(@DuseClientConfig() this.client, this.provider);
  
  void attach() {
    if (client.isLoggedIn) fetchUser();
  }
  
  Map<String, String> get parameters => provider.parameters;
  
  void fetchUser() {
    client.getCurrentUser().then((ent) {
      user = User.parse(ent);
    });
  }
  
  void logout() {
    window.localStorage.remove("token");
    this.user = null;
    this.client.logout();
  }
  
  bool get isLoggedIn => user != null;
}