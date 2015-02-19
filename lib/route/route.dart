library duseapp.route;

import 'dart:html' show window;

import 'package:angular/angular.dart';

const int NOT_AUTH = 0;
const int AUTH_NO_REG = 1;
const int AUTH_AND_REG = 2;

bool get isLoggedIn => window.localStorage.containsKey("token");

authView(Router router, ngView, int mode) {
  return (RouteEvent e) {
    if (mode == AUTH_AND_REG) {
      if (!isLoggedIn) {
        router.go('login', {});
        return;
      }
      if (!isLoggedIn) {
        router.go('register', {});
        return;
      }
    } else if (mode == AUTH_NO_REG) {
      if (!isLoggedIn) {
        router.go('login', {});
        return;
      }
      if (isLoggedIn) {
        router.go('secrets.all', {});
        return;
      }
    } else if (mode == NOT_AUTH) {
      if (isLoggedIn) {
        router.go('secrets.all', {});
          return;
        }
      }
      ngView(e);
   };
}

void router(Router router, RouteViewFactory view) {
  view.configure({
    'view_default': ngRoute(
        defaultRoute: true,
        enter: (RouteEnterEvent e) {
          if (!isLoggedIn) return router.go('login', {}, replace: true);
          return router.go("secrets.all", {});
        }),
    'register': ngRoute(
        path: '/register',
        enter: authView(router, view('view/register.html'), NOT_AUTH)),
    'postregister': ngRoute(
        path: '/postregister',
        enter: authView(router, view('view/post_register.html'), NOT_AUTH)),
    'login': ngRoute(
        path: '/login',
        enter: authView(router, view('view/login.html'), NOT_AUTH)),
    'secrets': ngRoute(
        path: '/secrets',
        mount: {
          'create': ngRoute(
              path: '/create',
              enter: authView(router, view('view/secret_form.html'), AUTH_AND_REG)),
          'single': ngRoute(
              path: '/:secretId',
              enter: authView(router, view('view/secret_single.html'), AUTH_AND_REG)),
          'all': ngRoute(
              path: '/all',
              enter: authView(router, view('view/secret_list.html'), AUTH_AND_REG))
        }),
    'users': ngRoute(
        path: '/users',
        mount: {
          'edit': ngRoute(
              path: '/:userId/edit',
              enter: authView(router, view('view/user_form.html'), AUTH_AND_REG)),
          'all': ngRoute(
              path: '/all',
              enter: authView(router, view('view/user_list.html'), AUTH_AND_REG)),
          'single': ngRoute(
              path: '/:userId',
              enter: authView(router, view('view/user_single.html'), AUTH_AND_REG))
        })
  });
}