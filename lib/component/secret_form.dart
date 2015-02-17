library duseapp.component.secret_form;

import 'dart:html' show querySelector, SelectElement, OptionElement, window;
import 'dart:async' show Future;

import 'package:angular/angular.dart';
import 'package:duse/duse.dart';

import 'package:duseapp/component/secret_list.dart';
import 'package:duseapp/global.dart';

@Component(
    selector: 'secret-form',
    templateUrl: 'packages/duseapp/component/secret_form.html',
    useShadowDom: false)
class SecretFormComponent implements AttachAware {
  List<User> users = [];
  List<int> selectedIds = [];
  
  String title;
  String secret;
  String privatePem;
  String password;
  bool isLoading = false;
  
  Router router;
  DuseClient client;
  
  SecretFormComponent(@DuseClientConfig() this.client, this.router);
  
  String get buttonText => isLoading ? "Creating..." : "Create";
  
  Future loadNonSelectableUsers() {
    return Future.wait([client.getCurrentUser(), client.getServerUser()])
                 .then((List users) {
      selectedIds.addAll(users.map((user) => user.id));
    });
  }
  
  @override
  void attach() {
    this.loadNonSelectableUsers().then((_) {
      this.client.listUsers().then((List receivedUsers) {
        receivedUsers.forEach((user) {
          if (!selectedIds.any((id) => user.id == id)) {
            users.add(User.parse(user));
          }
        });
      });
    });
  }
  
  List<int> get userIds {
    var select = querySelector("#userSelect") as SelectElement;
    var names = select.children.where((OptionElement child) => child.selected)
                               .map((OptionElement child) => child.value);
    
    return users.where((user) => names.contains(user.username))
                .map((User user) => user.id)
                .toList();
  }
  
  void create() {
    this.client.privateKey = this.privateKey;
    if ([title, secret].any(isEmpty)) return window.alert("Fill in all data");
    var ids = []..addAll(selectedIds)..addAll(userIds);
    
    this.client.createSecret(title, secret, ids).then((ent) {
      this.router.go("secrets.all", {});
    }).catchError((e) => window.alert(e.toString()));
  }
  
  void reset() {
    window.localStorage.remove("private_key");
  }
    
  String get privateKey {
    if (!isPrivateKeyPresent) {
      encryptAndStore("private_key", password, privatePem);
      return privatePem;
    }
    return retrieveAndDecrypt("private_key", password);
  }
  
  bool get isPrivateKeyPresent {
    return window.localStorage.containsKey("private_key");
  }
}