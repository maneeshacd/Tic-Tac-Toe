if @game.update(game_params)
  json.game     @game
  json.success  true
else
  json.errors       @game.errors
  json.success      false
end
