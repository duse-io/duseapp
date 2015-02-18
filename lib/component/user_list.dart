library duseapp.component.user_list_component;

import 'dart:async' show Future;

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

import 'package:duseapp/global.dart';

@Component(
    selector: 'user-list',
    templateUrl: 'packages/duseapp/component/user_list.html',
    useShadowDom: false)
class UserListComponent implements AttachAware {
  @NgTwoWay("users")
  List<User> users;
  DuseClient client;
  String usernameFilter = "";
  
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
    client.listUsers().then((List users) =>
        this.users = users.map(User.parse).toList());
  }
}