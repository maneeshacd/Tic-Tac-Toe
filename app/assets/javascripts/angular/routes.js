app.factory('Game', ['$resource', function($resource) {
  return $resource('/api/games', null, {
    'create': { method: 'POST' },
    'update': { url: '/api/games/:id', method: 'PATCH', params: {id: '@id'} }
  });
}]);

app.factory('GamePlayer', ['$resource', function($resource) {
  return $resource('/api/game_players', {id: '@id'}, {
    'all': { method: 'GET', isArray: false },
    'save': { method: 'POST'},
    'movement': { method: 'POST', url: '/api/game_players/:id/movement' },
  });
}]);

app.factory('Players', ['$resource', function($resource) {
  return $resource('/api/players', null, {
    'query':  {method: 'GET', isArray: false}
  });
}]);

app.factory('PlayerMovement', ['$resource', function($resource) {
  return $resource('/api/players/:id/movement', {id: '@id'}, {
    'movement':  { method:'POST', params: '@params' }
  });
}]);

