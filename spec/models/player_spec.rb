# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'Associations' do
    it { should have_many(:game_players) }
    it { should have_many(:games).through(:game_players) }
  end

  describe 'Validations' do
    subject { create(:player) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
