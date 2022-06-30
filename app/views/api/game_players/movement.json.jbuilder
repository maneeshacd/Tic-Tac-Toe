player_moves = GamePlayer.list(@game_player.game).pluck(:moves).flatten.count
json.winner                @winner
json.played_columns_count  player_moves
json.success               true
