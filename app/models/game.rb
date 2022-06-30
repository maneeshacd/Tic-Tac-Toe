class Game < ApplicationRecord
  enum :status, %i(inactive active completed)

  validates :status, presence: true

  has_many :game_players
  has_many :players, through: :game_players
  validates_length_of :players, maximum: 2

  def activate
    active! if players.count == 2
  end
end
