library duseapp.main;

import 'dart:html' show window;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:duse/duse.dart';
import 'package:restpoint/restpoint_client_client.dart';

import 'package:duseapp/route/route.dart';
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
  var url = const String.fromEnvironment("DUSE_URL",
      defaultValue: "https://duse.herokuapp.com/v1");
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
