# frozen_string_literal: true

class Player < ApplicationRecord
  enum :status, %i[inactive active]
  validates :name, presence: true, uniqueness: true

  has_many :game_players
  has_many :games, through: :game_players
end
