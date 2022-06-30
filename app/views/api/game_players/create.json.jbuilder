if @game_player.persisted?
  json.game_player  @game_player
  json.player       @player
  json.success      true
else
  json.errors       @game_player.errors
  json.success      false
end
