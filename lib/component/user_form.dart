library duseapp.component.user_form_component;

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

import 'package:duseapp/global.dart';

@Component(
    selector: 'user-form',
    templateUrl: 'packages/duseapp/component/user_form.html',
    useShadowDom: false)
class UserFormComponent implements AttachAware {
  RouteProvider provider;
  DuseClient client;
  
  User user;
  
  void set id(id) {
    if (id is String) id = int.parse(this.provider.parameters["userId"]);
    if (id is! int) throw new ArgumentError.value(id);
    this.client.getUser(id).then((entity) => user = User.parse(entity));
  }
  
  UserFormComponent(this.provider, @DuseClientConfig() this.client);
  
  void attach() {
    this.id = this.provider.parameters["userId"];
  }
  
  bool get userIsPresent => user != null;
}