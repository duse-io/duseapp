library duseapp.component.user_component;

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

import 'package:duseapp/global.dart';
import 'package:duseapp/component/main.dart';

@Component(
    selector: 'user',
    templateUrl: 'packages/duseapp/component/user.html',
    useShadowDom: false)
class UserComponent {
  RouteProvider provider;
  DuseClient client;
  MainComponent main;
  
  User user;
  
  String error;
  
  UserComponent(this.provider, @DuseClientConfig() this.client, this.main);
  
  @NgAttr("user-id")
  void set id(id) {
    if (null == id) id = this.provider.parameters["userId"];
    if (id is String) {
      try {
        id = int.parse(id);
      } on FormatException catch (e) {
        error = "Malformed user id $id";
        user = null;
        return;
      }
    }
    if (id is! int) throw new ArgumentError.value(id);
    this.client.getUser(id)
      .then((entity) => user = User.parse(entity))
      .catchError((e) =>
          error = "Could not get the specified user");
  }
  
  bool get userIsPresent => user != null;
  
  bool get isCurrentUser {
    if ([main.user, user].any((obj) => null == obj)) return false;
    return user.id == main.user.id;
  }
}