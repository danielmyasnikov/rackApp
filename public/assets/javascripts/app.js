(function() {
  var app;

  app = angular.module("rackApp", ["ngResource"]);

  app.factory("Member", function($resource) {
    return $resource('/api/members/:id', {
      id: '@id'
    }, {
      update: {
        method: 'PUT'
      }
    });
  });

  app.controller("MembersController", function($scope, Member) {
    $scope.members = Member.query();
    $scope.editing = false;
    $scope.switch_mode = function() {
      console.log('$scope.editing', $scope.editing);
      $scope.editing = false;
      return console.log('$scope.editing', $scope.editing);
    };
    $scope.create = function() {
      var member;
      member = new Member({
        username: $scope.member.username,
        registered: $scope.member.registered
      });
      $scope.members.push(member);
      return member.$save();
    };
    $scope["delete"] = function(user) {
      return user.$delete(function() {
        var member;
        return $scope.members = (function() {
          var _i, _len, _ref, _results;
          _ref = $scope.members;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            member = _ref[_i];
            if (member.id !== user.id) {
              _results.push(member);
            }
          }
          return _results;
        })();
      });
    };
    return $scope.update = function(member) {
      return member.$update();
    };
  });

}).call(this);
