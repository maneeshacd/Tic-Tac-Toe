class GamePlayer < ApplicationRecord
  belongs_to :player
  belongs_to :game

  scope :list, (lambda do |game|
    where(player_id: game.players.pluck(:id), game: game)
  end)

  def played_columns_count
    GamePlayer.where(
      player_id: game.players.pluck(:id), game: game
    ).pluck(:moves).flatten.count
  end

  def activate_game
    game.activate
  end
end
