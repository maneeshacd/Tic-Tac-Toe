# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'Associations' do
    it { should have_many(:game_players) }
    it { should have_many(:players).through(:game_players) }
  end

  describe 'Validations' do
    subject { create(:game) }

    it { should validate_length_of(:players) }
  end

  describe 'activate!' do
    context 'did not activate game when only 1 player joins' do
      let!(:player) { create(:player) }
      let!(:game) { create(:game, players: [player]) }

      it 'should not activate' do
        game.activate!
        expect(game.status).not_to eq('active')
      end
    end

    context 'activate game when 2 players joins' do
      let!(:players) { create_list(:player, 2) }
      let!(:game) { create(:game, players:) }

      it 'should activate' do
        game.activate!
        expect(game.status).to eq('active')
      end
    end
  end
end
