library duseapp.component.user_component;

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

import 'package:duseapp/global.dart';

@Component(
    selector: 'user',
    useShadowDom: false)
class UserComponent implements AttachAware {
  RouteProvider provider;
  
  DuseClient client;
  
  UserComponent(this.provider, @DuseClientConfig() this.client);
  
  void attach() {
    var id = int.parse(this.provider.parameters["userId"]);
  }
}