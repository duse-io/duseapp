library duseapp.component.user_component;

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

import 'package:duseapp/global.dart';
import 'package:duseapp/component/main.dart';

@Component(
    selector: 'user',
    templateUrl: 'packages/duseapp/component/user.html',
    useShadowDom: false)
class UserComponent implements AttachAware {
  RouteProvider provider;
  DuseClient client;
  MainComponent main;
  
  User user;
  
  UserComponent(this.provider, @DuseClientConfig() this.client, this.main);
  
  void attach() {
    var id = int.parse(this.provider.parameters["userId"]);
    this.client.getUser(id).then((entity) => user = User.parse(entity));
  }
  
  bool get userIsPresent => user != null;
  
  bool get isCurrentUser => user.id == main.user.id;
}