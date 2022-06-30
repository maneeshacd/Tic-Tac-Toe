app.controller('TicTacToeCtrl', ['$scope', 'GamePlayer', 'Game', 'GameDataService', 'PlayerMovement', '$interval', '$timeout', function($scope, GamePlayer, Game, GameDataService, PlayerMovement, $interval, $timeout) {
  var player1_sym = 'X';
  var player2_sym = 'O';
  $scope.active_players = [];
  $scope.currentPlayerSymbol = player1_sym;
  $scope.gameStarted = false;
  $scope.timeout = false;

  var initData = function() {
    $scope.numberToWin = 3;
    $scope.winner = null;
    $scope.draw = null;
    $scope.CountDown = null;
    $scope.board = GameDataService.getBoard();
    $scope.timeout = false;
  };

  $scope.newGame = function() {
    Game.create().$promise.then(function(response) {
      if(response.success == true){
        $scope.history = false
        $scope.gameStarted = true;
        $scope.game = response.game
        $scope.active_players = [];
        $scope.errors = false
      } else {
        $scope.errors = response.errors
      }
    });
    initData();
  };

  $scope.createPlayer = function(player_name, symbol) {
    GamePlayer.save({game_id: $scope.game.id, name: player_name, status: 1, symbol: symbol}).$promise.then(function(response) {
      if(response.success == true){
        $scope.errors = false
        $scope.gamePlayer = response.game_player;
        $scope.active_players.push({id: $scope.gamePlayer.id, name: response.player.name, symbol: $scope.gamePlayer.symbol})
        $scope.currentPlayer = $scope.active_players[0]
        if($scope.active_players.length == 1) {
          $scope.countDownToConnect()
        }
        if($scope.active_players.length == 2) {
          $scope.CountDown = null;
          $interval.cancel($scope.promise);
        }
      } else {
        $scope.errors = response.errors
      }
    });
  };

  var changePlayer = function() {
    $scope.currentPlayer = ($scope.currentPlayer === $scope.active_players[0])
      ? $scope.active_players[1]
      : $scope.active_players[0];
  };

  $scope.playTurn = function($event, positionInfo) {
    if ($scope.winner) {
      return;
    }

    if (positionInfo.player !== null) {
      return;
    }

    positionInfo.player = $scope.currentPlayer.symbol;
    GamePlayer.movement({id: $scope.currentPlayer.id, position_info: positionInfo}).$promise.then(function(response) {
      if(response.success == true){
        $scope.errors = false
        $scope.winner = response.winner
        if (!$scope.winner && response.played_columns_count === 9) {
          $scope.draw = true;
          Game.update({id: $scope.game.id, status: 2}).$promise.then(function(response) {})
        }
        if ($scope.winner) {
          Game.update({id: $scope.game.id, status: 2}).$promise.then(function(response) {})
        } else {
          changePlayer()
        }
      } else {
        $scope.errors = response.errors
      }
    });
  };

  $scope.fetchHistory = function($event, positionInfo) {
    $scope.gameStarted = false
    Game.query().$promise.then(function(response) {
      $scope.history = true
      $scope.games = response.games
    });
  };

  $scope.playerNames = function(players) {
    if(players.length > 0){
      return _.join(_.map(players, 'name'), ', ');
    }

  }

  $scope.findWinner = function(players) {
    return _.find(players, ['winner', true]);
  }

  $scope.countDownToConnect = function() {
    $interval.cancel($scope.promise);
    $scope.CountDown = 60;
    $scope.promise = $interval(function () {
        if ($scope.CountDown > 0) {
            $scope.CountDown--;
        } else {
            $scope.timeout = true;
            $scope.gameStarted = false;
            $interval.cancel($scope.promise);
        }
    }, 1000, 0);
  };

  initData()
}]);

app.factory('GameDataService', function() {
  var service = {};
  var createBoard = function(boardsize) {
    var data = [];
      for (var i = 0; i < boardsize; i++) {
        for (var j = 0; j < boardsize; j++) {
          data.push({'row':i, 'col': j, 'player': null});
        }
      }
    return data;
  };

  service.getBoard = function() {
    return createBoard(3);
  };

  return service;
});
