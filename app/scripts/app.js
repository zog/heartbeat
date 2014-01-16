'use strict';

angular.module('heartbeatApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'heartbeatServices',
  'webStorageModule'
])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
