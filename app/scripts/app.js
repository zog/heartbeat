'use strict';

angular.module('heartbeatApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'heartbeatServices'
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
