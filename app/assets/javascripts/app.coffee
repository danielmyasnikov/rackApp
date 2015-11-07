myApp = angular.module('rackApp', [ngResource])

myApp.factory('User', ($resource) ->
  $resource('/api/users/:id',
    id: '@id'
  )
)

myApp.controller('UsersController', ($scope, User) ->
  $scope.users = User.query();
)