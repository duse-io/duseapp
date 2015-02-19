library duseapp.component.main;

import 'dart:html' show window;

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

import 'package:duseapp/model/alert.dart';
import 'package:duseapp/global.dart';

@Component(
    selector: 'main',
    templateUrl: 'packages/duseapp/component/main.html',
    useShadowDom: false)
class MainComponent implements AttachAware, ScopeAware {
  static const List<String> _WHITELIST_ROUTES =
      const ["/login", "/register", "/post_register"];
  
  User user;
  
  Set<Alert> alerts = new Set<Alert>();
  
  DuseClient client;
  
  RouteProvider provider;
  
  Router router;
  
  bool isLoading = false;
  
  void set scope(Scope scope) {
    scope.on("alert").listen((event) {
      if (event.data != null && event.data is Alert) alerts.add(event.data);
    });
    
    scope.on("load").listen((event) {
      if (null == event.data || event.data is! bool)
        throw new ArgumentError.value(event.data);
      isLoading = event.data;
    });
  }
    
  MainComponent(@DuseClientConfig() this.client, this.provider, this.router) {
  }
  
  void dismiss(Alert alert) {
    alerts.remove(alert);
  }
  
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