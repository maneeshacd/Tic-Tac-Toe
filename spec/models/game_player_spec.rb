# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GamePlayer, type: :model do
  describe 'Associations' do
    it { should belong_to(:game) }
    it { should belong_to(:player) }
  end

  describe 'Validations' do
    let(:game) { create(:game) }
    let(:player) { create(:player) }
    subject { create(:game_player, player:, game:) }

    it { should validate_uniqueness_of(:player_id).scoped_to(:game_id) }
  end

  describe 'list' do
    describe 'includes game_players for a particular game' do
      let(:game) { create(:game) }
      let(:players) { create_list(:player, 2) }

      it 'includes game players for a game' do
        game.players = players
        expect(GamePlayer.list(game)).to include(
          an_object_having_attributes(
            player_id: players.first.id, game_id: game.id
          ),
          an_object_having_attributes(
            player_id: players.second.id, game_id: game.id
          )
        )
      end
    end
  end

  describe 'activate game' do
    let(:game) { create(:game) }
    let(:players) { create_list(:player, 2) }

    it 'activates game' do
      game.players = players
      game.game_players.first.activate_game
      expect(game.status).to eq('active')
    end
  end
end
