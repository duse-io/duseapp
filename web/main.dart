library duseapp.main;

import 'dart:html' show window;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:duse/duse.dart';
import 'package:restpoint/restpoint_client_client.dart';

import 'package:duseapp/component/register.dart';
import 'package:duseapp/component/login.dart';
import 'package:duseapp/component/user.dart';
import 'package:duseapp/global.dart';

DuseClient get client {
  var _client = new DuseClient(
    Uri.parse("https://duse.herokuapp.com/v1"),
    new ClientClientFactory());
  if (!_client.isLoggedIn) {
    _client.token = window.localStorage["token"];
  }
  return _client;
}


class DuseAppModule extends Module {
  DuseAppModule() {
    bind(RouteInitializerFn, toValue: router);
    bind(RegisterComponent);
    bind(LoginComponent);
    bind(UserComponent);
    bind(DuseClient,
        withAnnotation: const DuseClientConfig(),
        toValue: client);
    bind(NgRoutingUsePushState,
        toValue: new NgRoutingUsePushState.value(false));
  }
}



void main() {
  applicationFactory()
    .addModule(new DuseAppModule())
    .run();
}


void router(Router router, RouteViewFactory views) {
  views.configure({
    'view_default': ngRoute(
        defaultRoute: true,
        enter: (RouteEnterEvent e) =>
            router.go('login', {},
                replace: true)),
    'register': ngRoute(
        path: '/register',
        view: 'view/register.html'),
    'login': ngRoute(
        path: '/login',
        view: 'view/login.html'),
    'user': ngRoute(
        path: '/user',
        view: 'view/user.html')
  });
}
