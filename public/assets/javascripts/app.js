(function() {
  var myApp;

  myApp = angular.module('rackApp', [ngResource]);

  myApp.factory('User', function($resource) {
    return $resource('/api/users/:id', {
      id: '@id'
    });
  });

  myApp.controller('UsersController', function($scope, User) {
    return $scope.users = User.query();
  });

}).call(this);
