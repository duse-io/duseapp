library duseapp.component.user_list_component;

import 'dart:async' show Future;

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

import 'package:duseapp/global.dart';
import 'package:duseapp/model/alert.dart';

@Component(
    selector: 'user-list',
    templateUrl: 'packages/duseapp/component/user_list.html',
    useShadowDom: false)
class UserListComponent implements AttachAware, ScopeAware {
  @NgTwoWay("users")
  List<User> users;
  DuseClient client;
  String usernameFilter = "";
  Scope scope;
  
  UserListComponent(@DuseClientConfig() this.client);
  
  
  @NgOneWay("user-ids")
  void set ids(List<int> ids) {
    if (null == ids) {
      _loadAllUsers();
      return;
    }
    if (ids.isEmpty) {
      users = [];
      return;
    }
    Future.wait(ids.map((id) => client.getUser(id).then(User.parse)))
          .then((List<User> loaded) => this.users = loaded);
  }
  
  void attach() {
    if (null == users) _loadAllUsers();
  }
  
   void _loadAllUsers() {
     scope.emit("load", true);
     client.listUsers().then((List users) =>
        this.users = users.map(User.parse).toList())
           .catchError((e) =>
               scope.emit("alert", new Alert.warning("Could not load users")))
           .whenComplete(() => scope.emit("load", false));
  }
}