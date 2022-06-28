class Player < ApplicationRecord
  enum :status, %i(inactive active)
  validates :name, presence: true
end
