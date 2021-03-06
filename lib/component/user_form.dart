library duseapp.component.user_form_component;

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

import 'package:duseapp/global.dart';
import 'package:duseapp/model/alert.dart';

@Component(
    selector: 'user-form',
    templateUrl: 'packages/duseapp/component/user_form.html',
    useShadowDom: false)
class UserFormComponent implements AttachAware, ScopeAware {
  RouteProvider provider;
  DuseClient client;
  
  String username;
  String email;
  String password;
  String newPassword;
  String newPasswordRepeat;
  Router router;
  
  User user;
  Scope scope;
  
  void set id(id) {
    if (id is String) id = int.parse(this.provider.parameters["userId"]);
    if (id is! int) throw new ArgumentError.value(id);
    this.client.getUser(id).then((entity) => user = User.parse(entity));
  }
  
  UserFormComponent(this.provider, @DuseClientConfig() this.client, this.router);
  
  void attach() {
    this.id = this.provider.parameters["userId"];
  }
  
  void update() {
    var body = {
      "current_password": password
    };
    if (!isBlank(username)) body["username"] = username;
    if (!isBlank(email)) body["email"] = email;
    
    if (![newPassword, newPasswordRepeat].any(isBlank)) {
      if (newPassword == newPasswordRepeat) body["password"] = newPassword;
    }
    
    scope.emit("load", true);
    this.client.updateUser(user.id, body).then((ent) {
      router.go("users.single", {"userId": user.id});
    }).catchError((e) {
      scope.emit("alert", new Alert.warning("Could not update the user"));
    }).whenComplete(() => scope.emit("load", false));
  }
  
  bool get userIsPresent => user != null;
}

bool isBlank(String str) => str == null || str.isEmpty;