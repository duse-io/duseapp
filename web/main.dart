library duseapp.main;

import 'dart:html' show window;
import 'dart:async' show Future;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:duse/duse.dart';
import 'package:restpoint/restpoint_client_client.dart';

import 'package:duseapp/component/main.dart';
import 'package:duseapp/component/register.dart';
import 'package:duseapp/component/login.dart';
import 'package:duseapp/component/secret_list.dart';
import 'package:duseapp/component/secret.dart';
import 'package:duseapp/component/secret_form.dart';
import 'package:duseapp/component/load_button.dart';
import 'package:duseapp/component/user.dart';
import 'package:duseapp/component/user_form.dart';
import 'package:duseapp/component/user_list.dart';
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
    bind(MainComponent);
    bind(RegisterComponent);
    bind(LoginComponent);
    bind(SecretListComponent);
    bind(SecretComponent);
    bind(SecretFormComponent);
    bind(LoadButtonComponent);
    bind(UserComponent);
    bind(UserFormComponent);
    bind(UserListComponent);
    bind(DuseClient,
        withAnnotation: const DuseClientConfig(),
        toValue: client);
    bind(NgRoutingUsePushState,
        toValue: new NgRoutingUsePushState.value(false));
  }
}



void main() {
  var injector = applicationFactory()
    .addModule(new DuseAppModule())
    .run();
}

bool get isLoggedIn => window.localStorage.containsKey("token");

void checkAuthentication(RoutePreEnterEvent e) {
  if (isLoggedIn) {
    return e.allowEnter(new Future.value(true));
  }
  return e.allowEnter(new Future.value(false));
}


void router(Router router, RouteViewFactory views) {
  views.configure({
    'view_default': ngRoute(
        defaultRoute: true,
        enter: (RouteEnterEvent e) {
          if (!isLoggedIn) return router.go('login', {}, replace: true);
          return router.go("secrets.all", {});
        }),
    'register': ngRoute(
        path: '/register',
        view: 'view/register.html'),
    'postregister': ngRoute(
        path: '/postregister',
        view: '/view/post_register.html'),
    'login': ngRoute(
        path: '/login',
        preEnter: (RoutePreEnterEvent e) {
          if (isLoggedIn) e.allowEnter(new Future.value(false));
        },
        view: 'view/login.html'),
    'secrets': ngRoute(
        path: '/secrets',
        preEnter: checkAuthentication,
        mount: {
          'create': ngRoute(
              path: '/create',
              preEnter: checkAuthentication,
              view: 'view/secret_form.html'),
          'single': ngRoute(
              path: '/:secretId',
              preEnter: checkAuthentication,
              view: 'view/secret_single.html'),
          'all': ngRoute(
              path: '/all',
              preEnter: checkAuthentication,
              view: 'view/secret_list.html')
        }),
    'users': ngRoute(
        path: '/users',
        preEnter: checkAuthentication,
        mount: {
          'edit': ngRoute(
              path: '/:userId/edit',
              preEnter: checkAuthentication,
              view: 'view/user_form.html'),
          'all': ngRoute(
              path: '/all',
              preEnter: checkAuthentication,
              view: 'view/user_list.html'),
          'single': ngRoute(
              path: '/:userId',
              preEnter: checkAuthentication,
              view: 'view/user_single.html')
        })
  });
}
