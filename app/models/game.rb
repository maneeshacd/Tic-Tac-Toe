# frozen_string_literal: true

class Game < ApplicationRecord
  enum :status, %i[inactive active completed]

  has_many :game_players
  has_many :players, through: :game_players
  validates_length_of :players, maximum: 2

  def activate!
    active! if players.count == 2
  end
end
