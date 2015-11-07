app = angular.module("rackApp", ["ngResource"])

app.factory("Member", ($resource) ->
  $resource('/api/members/:id',
    (id: '@id'),
    (update: 
      method: 'PUT'
    )
  )
)

app.controller("MembersController", ($scope, Member) ->
  $scope.members = Member.query()
  $scope.editing = false

  $scope.switch_mode = ->
    console.log('$scope.editing', $scope.editing)
    $scope.editing = false
    console.log('$scope.editing', $scope.editing)

  $scope.create = ->
    member = new Member(
      username: $scope.member.username,
      registered: $scope.member.registered
    )
    $scope.members.push(member)
    member.$save()

  $scope.delete = (user) ->
    user.$delete( ->
      $scope.members = (member for member in $scope.members when member.id != user.id)
    )

  $scope.update = (member) ->
    member.$update()
)