library duseapp.test.component.login;

import 'package:mock/mock.dart';
import 'package:unittest/unittest.dart';

import 'package:duseapp/component/login.dart';
import 'package:duseapp/model/alert.dart';

import 'mock.dart';


defineLoginTests() {
  group("LoginComponent", () {
    group("login", () {
      group("Early exit", () {
        test("Exit if no password", () {
          var comp = new LoginComponent(null, null, null);
          var scope = new ScopeMock();
          
          var call = callsTo("emit", "alert",
              new Alert.warning("Username and/or Password blank"));
          scope.when(call)
               .thenReturn(-100);
          comp.scope = scope;
          comp.username = "username";
          expect(comp.login(), equals(-100));
          scope.getLogs(call).verify(happenedOnce);
        });
        
        test("Exit if no password", () {
          var comp = new LoginComponent(null, null, null);
          var scope = new ScopeMock();
          
          var call = callsTo("emit", "alert",
              new Alert.warning("Username and/or Password blank"));
          scope.when(call)
               .thenReturn(-100);
          comp.scope = scope;
          comp.password = "password";
          expect(comp.login(), equals(-100));
          scope.getLogs(call).verify(happenedOnce);
        });
        
        test("Exit if both not present", () {
          var comp = new LoginComponent(null, null, null);
          var scope = new ScopeMock();
          
          var call = callsTo("emit", "alert",
              new Alert.warning("Username and/or Password blank"));
          scope.when(call)
               .thenReturn(-100);
          comp.scope = scope;
          expect(comp.login(), equals(-100));
          scope.getLogs(call).verify(happenedOnce);
        });
      });
    });
  });
}