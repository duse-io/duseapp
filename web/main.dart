// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:duseapp/component/login.dart';
import 'package:duseapp/annotations.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:duse/duse.dart';
import 'package:restpoint/restpoint_client_client.dart';

final client = new DuseClient(Uri.parse("https://duse.herokuapp.com/v1"),
    new ClientClientFactory());


class DuseAppModule extends Module {
  DuseAppModule() {
    bind(DuseClient, withAnnotation: duseClient, toValue: client);
    bind(LoginComponent);
  }
}



void main() {
  applicationFactory()
    .addModule(new DuseAppModule())
    .run();
}
