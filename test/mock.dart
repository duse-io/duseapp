library duseapp.test.mock;

import 'package:angular/angular.dart';
import 'package:mock/mock.dart';

@proxy
class ScopeMock extends Mock implements Scope {
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}