if @updated
  json.game     @game
  json.success  true
else
  json.errors       @game.errors
  json.success      false
end
