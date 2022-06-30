json.games @games do |game|
  json.game_id    game.id
  game_players = game.game_players
  if game_players.count == 2
    json.game_players game_players do |game_player|
      json.name     game_player.player&.name
      json.winner   game_player.winner
    end
  end
end
