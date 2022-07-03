# frozen_string_literal: true

class GamePlayer < ApplicationRecord
  belongs_to :player
  belongs_to :game

  validates_uniqueness_of :player_id, scope: :game_id
  validates :symbol, inclusion: {
    in: %w[X O],
    message: '%{value} is not a valid symbol'
  }, allow_nil: true

  scope :list, (lambda do |game|
    where(player_id: game.players.pluck(:id), game:)
  end)

  def activate_game
    game.activate!
  end
end
